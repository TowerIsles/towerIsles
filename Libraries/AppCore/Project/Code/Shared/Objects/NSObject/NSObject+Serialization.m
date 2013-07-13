#import "NSObject+Serialization.h"
#import <objc/runtime.h>
#import "AppCoreAsserts.h"
#import "AppCoreUtilities.h"

static NSMutableDictionary* deserializersByPropertyNameByClass;
static NSMutableDictionary* classesByPropertyNameByClass;

@implementation NSObject (Serialization)

+ (void)registerDeserializer:(DeserializerBlock)deserializerBlock
                 forProperty:(NSString*)propertyName
{
    deserializerBlock = [deserializerBlock copy];
    
    CheckNotNull(deserializersByPropertyNameByClass[self.class]);
    
    NSMutableDictionary* deserializersByPropertyName = deserializersByPropertyNameByClass[self.class];
    CFDictionarySetValue((CFMutableDictionaryRef)deserializersByPropertyName,
                         propertyName,
                         deserializerBlock);
    
    [deserializerBlock release];
}

+ (void)registerClass:(Class)classToUse
         forContainer:(NSString*)propertyName
{
    if (classesByPropertyNameByClass == nil)
    {
        classesByPropertyNameByClass = [NSMutableDictionary new];
    }
    
    if (classesByPropertyNameByClass[self.class] == nil)
    {
        classesByPropertyNameByClass[(id<NSCopying>)self.class] = [NSMutableDictionary new];
    }
    
    NSMutableDictionary* classesByPropertyName = classesByPropertyNameByClass[self.class];
    CFDictionarySetValue((CFMutableDictionaryRef)classesByPropertyName, propertyName, classToUse);
}


static DeserializerBlock deserializerForContainerProperty(Class class, NSString* propertyName)
{
    NSMutableDictionary* deserializersByPropertyName = deserializersByPropertyNameByClass[class];
    
    if (deserializersByPropertyName == nil)
    {
        deserializersByPropertyName = [NSMutableDictionary new];
        if (deserializersByPropertyNameByClass == nil)
        {
            deserializersByPropertyNameByClass = [NSMutableDictionary new];
        }
        deserializersByPropertyNameByClass[(id<NSCopying>)class] = deserializersByPropertyName;
        [class setupSerialization];
    }
    
    return (DeserializerBlock)CFDictionaryGetValue((CFDictionaryRef)deserializersByPropertyName, propertyName);
}

static Class classForContainerProperty(Class class, NSString* propertyName)
{
    NSMutableDictionary* classesByPropertyName = classesByPropertyNameByClass[class];
    
    if (classesByPropertyName == nil)
    {
        return nil;
    }
    
    return (Class)CFDictionaryGetValue((CFDictionaryRef)classesByPropertyName, propertyName);
}

Class classForProperty(objc_property_t property)
{
    if (property != nil)
    {
        char rawTypeString[256];
        
        const char* attrs = property_getAttributes(property);
        
        if (attrs != NULL)
        {
            const char * e = strchr(attrs, ',');
            
            if (e != NULL)
            {
                int len = (int)(e - attrs);
                
                memcpy(rawTypeString, attrs, len);
                
                rawTypeString[len] = '\0';
                
                if (rawTypeString[0] == 'T' &&
                    rawTypeString[1] == '@' && rawTypeString[2] != 0)
                {
                    const char* startOfClassName = rawTypeString + 3;
                    const char* endOfClassName = strstr(startOfClassName, "\"");
                    
                    if (endOfClassName != NULL)
                    {
                        char buffer[255];
                        unsigned long classNameLength = endOfClassName - startOfClassName;
                        strncpy(buffer, startOfClassName, classNameLength);
                        buffer[classNameLength] = 0;
                        
                        Class propertyClass = objc_getClass(buffer);
                        
                        return propertyClass;
                    }
                }
            }
        }
    }

	return nil;
}

- (void)setValuesWithSerializedRepresentation:(NSDictionary*)serializedRepresentation
{
    Class selfClass = self.class;
    
    SEL setValueForKeySelector = @selector(setValue:forKey:);
    void (*setValueForKey)(id, SEL, id, NSString*) = (void (*)(id, SEL, id, NSString*))class_getMethodImplementation(selfClass,
                                                                                                                     setValueForKeySelector);
    
    for (NSString* propertyName in serializedRepresentation)
	{
        NSDictionary* sourceDictionary = serializedRepresentation;
        
        id propertyValue = (id)CFDictionaryGetValue((CFDictionaryRef)sourceDictionary,
                                                    propertyName);

        const char* propertyNameUTF8 = CFStringGetCStringPtr((CFStringRef)propertyName,
                                                             kCFStringEncodingMacRoman);
        
        DeserializerBlock deserializerBlock = deserializerForContainerProperty(selfClass, propertyName);
		
		if (deserializerBlock != nil)
		{
            deserializerBlock(self, propertyValue);
			continue;
		}
		
        objc_property_t property = class_getProperty(selfClass, propertyNameUTF8);
        Class propertyClass = classForProperty(property);
        
		if (propertyClass != nil)
		{
            if (propertyValue == [NSNull null])
            {
                setValueForKey(self,
                               setValueForKeySelector,
                               nil,
                               propertyName);
            }
			// Special case for dictionaries
			else if ([propertyClass isKindOfClass:object_getClass(kDictionaryClass)])
			{
                Class registeredClass = classForContainerProperty(selfClass, propertyName);
                
                if (registeredClass == nil)
                {
                    setValueForKey(self,
                                   setValueForKeySelector,
                                   propertyValue,
                                   propertyName);
                    continue;
                }
                
                NSMutableDictionary* deserializedDictionary = [NSMutableDictionary new];
                
                for (NSString* serializedContainedObjectKey in propertyValue)
                {
                    id serializedContainedObject = (id)CFDictionaryGetValue((CFDictionaryRef)propertyValue,
                                                                            serializedContainedObjectKey);
                    
                    Class classToUse = registeredClass;
                    
                    if (classToUse == kBasicSerializedClassesPlaceholderClass)
                    {
                        if ([serializedContainedObject isKindOfClass:kNumberClass])
                            classToUse = kNumberClass;
                        else if ([serializedContainedObject isKindOfClass:kStringClass])
                            classToUse = kStringClass;
                        else if ([serializedContainedObject isKindOfClass:kArrayClass])
                            classToUse = kMutableArrayClass;
                        else
                            classToUse = kObjectClass;
                    }
                    
                    id deserializedContainedObject = [classToUse objectFromSerializedRepresentation:serializedContainedObject];
                    
                    CFDictionarySetValue((CFMutableDictionaryRef)deserializedDictionary,
                                         serializedContainedObjectKey,
                                         deserializedContainedObject);
                }
                
                setValueForKey(self,
                               setValueForKeySelector,
                               deserializedDictionary,
                               propertyName);
                
                [deserializedDictionary release];
			}
			// Special case for arrays
			else if ([propertyClass isKindOfClass:object_getClass(kArrayClass)])
			{
                Class registeredClass = classForContainerProperty(selfClass, propertyName);
                
                if (registeredClass == nil)
                {
                    setValueForKey(self,
                                   setValueForKeySelector,
                                   propertyValue,
                                   propertyName);
                    continue;
                }
				
                NSMutableArray* deserializedArray = [NSMutableArray new];
                
                for (id serializedContainedObject in propertyValue)
                {
                    Class classToUse = registeredClass;
                    
                    if (classToUse == kBasicSerializedClassesPlaceholderClass)
                    {
                        if ([serializedContainedObject isKindOfClass:kNumberClass])
                            classToUse = kNumberClass;
                        else if ([serializedContainedObject isKindOfClass:kStringClass])
                            classToUse = kStringClass;
                        else if ([serializedContainedObject isKindOfClass:kArrayClass])
                            classToUse = kMutableArrayClass;
                        else
                            classToUse = kObjectClass;
                    }
                    
                    id deserializedContainedObject = [classToUse objectFromSerializedRepresentation:serializedContainedObject];
                    
                    CFArrayAppendValue((CFMutableArrayRef)deserializedArray,
                                       deserializedContainedObject);
                }
                
                setValueForKey(self,
                               setValueForKeySelector,
                               deserializedArray,
                               propertyName);
                
                [deserializedArray release];
			}
            else
            {
                id deserializedObject = [propertyClass objectFromSerializedRepresentation:propertyValue];
                
                setValueForKey(self,
                               setValueForKeySelector,
                               deserializedObject,
                               propertyName);
            }
		}
		else
		{
            // If you crash here, you might be trying to serialize a c struct.
            // Use something like : SerializationHandler_Type(IvarName)
            setValueForKey(self,
                           setValueForKeySelector,
                           propertyValue,
                           propertyName);
		}
	}
}

+ (id)objectFromSerializedRepresentation:(NSDictionary*)serializedRepresentation
{
	CheckIsKindOfClass(serializedRepresentation, NSDictionary)
	
	id result = [[[self.class alloc] init] autorelease];
	
    [result setValuesWithSerializedRepresentation:serializedRepresentation];
    
	return result;
}

+ (void)setupSerialization {}

+ (Class)classForIvar:(Ivar)ivar
{
	if (ivar != nil)
    {
        const char* encoding = ivar_getTypeEncoding(ivar);
        
        // Check that this is an object
        if (encoding[0] == '@')
        {
            unsigned int len = (unsigned int)strlen(encoding);
            
            // Check that this is not an id type (it must have a class in the format @"SomeClass"
            if (len >= 4)
            {
                char buffer[256];
                
                // Skip the opening @ and "
                memcpy(buffer, encoding + 2, strlen(encoding));
                
                // Chop off the closing "
                buffer[len - 3] = 0;
                
                return objc_getClass(buffer);
            }
        }
    }
    return nil;
}

void serializedRepresentationRecursive(id self, Class currentClass, id result)
{
    unsigned int numberOfProperties = 0;
	objc_property_t* propertyList = class_copyPropertyList(currentClass, &numberOfProperties);
	
    BOOL serializeByDefault = class_conformsToProtocol(currentClass, @protocol(SerializeByDefault));
    
	for (unsigned int propertyIndex = 0; propertyIndex < numberOfProperties; ++propertyIndex)
	{
        objc_property_t property = propertyList[propertyIndex];
		const char* propertyName = property_getName(property);
        NSString* propertyNameString = [NSString stringWithUTF8String:propertyName];
        
        BOOL shouldSerialize = serializeByDefault;
        
        if (!serializeByDefault)
        {
            char shouldSerializeSelectorString[256];
            snprintf(shouldSerializeSelectorString, 256, "serialize_%s", propertyName);
            SEL shouldSerializeSelector = sel_getUid(shouldSerializeSelectorString);
            
            shouldSerialize = class_getInstanceMethod([self class], shouldSerializeSelector) != nil;
        }
        
        if (shouldSerialize)
        {
            id serializedValueToSet = [self valueForKey:propertyNameString];
            
            if (serializedValueToSet == nil)
            {
                serializedValueToSet = NSNull.null;
            }
            else
            {
                serializedValueToSet = [serializedValueToSet serializedRepresentation];
            }
            
            [result setObject:serializedValueToSet
                       forKey:propertyNameString];
        }
	}
	
	free(propertyList);
	
	Class nextClass = [currentClass superclass];
	
	if (nextClass != nil && nextClass != kObjectClass)
	{
		serializedRepresentationRecursive(self, nextClass, result);
	}
}

- (id)serializedRepresentation
{
	NSMutableDictionary* result = [[NSMutableDictionary new] autorelease];
	    
	serializedRepresentationRecursive(self, self.class, result);
	
	return result;
}

@end

@implementation NSNumber (SerializedObject)

- (id)serializedRepresentation
{
	return self;
}

@end

@implementation NSArray (SerializedObject)

- (id)serializedRepresentation
{
	NSMutableArray* result = [[NSMutableArray new] autorelease];
	
	for (id object in self)
	{
		[result addObject:[object serializedRepresentation]];
	}
	
	return result;
}

@end

@implementation NSString (SerializedObject)

- (id)serializedRepresentation
{
	return self;
}

@end

@implementation NSNull (SerializedObject)

- (id)serializedRepresentation
{
    return self;
}

@end

@implementation NSDictionary (SerializedObject)

- (id)serializedRepresentation
{
	NSMutableDictionary* result = [[NSMutableDictionary new] autorelease];
	
	for (id key in self)
	{
		id object = [self objectForKey:key];
		
		[result setObject:[object serializedRepresentation]
				   forKey:key];
	}
	
	return result;
}

@end

@implementation NSString (DeserializedObject)

+ (id)objectFromSerializedRepresentation:(id)serializedObject
{
	return serializedObject;
}

@end

@implementation NSNumber (DeserializedObject)

+ (id)objectFromSerializedRepresentation:(id)serializedObject
{
	return serializedObject;
}

@end

@implementation BasicSerializedClassesPlaceholder
@end