#import "ResourceManager.h"
#import "AppCoreAsserts.h"
#import "JSONKit.h"
#import "NSObject+Serialization.h"
#import "AppCoreUtilities.h"

@interface ResourceManager ()
{
	
}

@end


@implementation ResourceManager

+ (BOOL)doesResourceAtPathExist:(NSString*)resourceName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:resourceName];
}

+ (NSData*)dataForResourceInBundle:(NSString*)resourceName
{
	return [NSData dataWithContentsOfFile:[self formatPathForResourceInBundleWithName:resourceName]];
}

+ (NSString*)formatPathForResourceInBundleWithName:(NSString*)resourceName
{
    NSString* path = [[NSBundle mainBundle] pathForResource:Format(@"bundle/%@", resourceName)
                                                     ofType:nil];

    CheckTrue([ResourceManager doesResourceAtPathExist:path])
        
    return path;
}

+ (NSDictionary*)internal_dataForResourceAtPath:(NSString*)path
{
	CheckNotNull(path);
	
	// Load Configuration File
	NSData* configurationJSONData = [NSData dataWithContentsOfFile:path];
    
	CheckNotNull(configurationJSONData);
	
    static NSError* error = nil;
    
    if (error == nil)
        error = [NSError new];
    
	NSMutableDictionary* configurationDictionary = [configurationJSONData mutableObjectFromJSONDataWithParseOptions:JKParseOptionStrict
                                                                                                              error:&error];
	CheckNotNull(configurationDictionary);
	
	return configurationDictionary;
}

+ (id)configurationObjectForResourceAtPath:(NSString*)resourceName
                                usingClass:(Class)configurationClass
{
    NSDictionary* dictionary = [self internal_dataForResourceAtPath:resourceName];
    
    CheckNotNull(dictionary);
    
    if (dictionary == nil)
        return nil;
    
    if (configurationClass == kDictionaryClass)
        return dictionary;
    
	return [configurationClass objectFromSerializedRepresentation:dictionary];
}

+ (id)configurationObjectForResourceInBundleWithName:(NSString*)resourceName
                                          usingClass:(Class)configurationClass
{
    return [ResourceManager configurationObjectForResourceAtPath:[ResourceManager formatPathForResourceInBundleWithName:resourceName]
                                                      usingClass:configurationClass];
}

@end
