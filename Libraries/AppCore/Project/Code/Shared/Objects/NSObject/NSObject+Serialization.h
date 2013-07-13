#include <objc/runtime.h>

typedef void (^DeserializerBlock)(id instance, id serializedRepresentation);

@interface NSObject (Serialization)

+ (void)registerDeserializer:(DeserializerBlock)deserializerBlock
                 forProperty:(NSString*)propertyName;

+ (void)registerClass:(Class)classToUse
         forContainer:(NSString*)propertyName;

- (void)setValuesWithSerializedRepresentation:(NSDictionary*)serializedRepresentation;

+ (id)objectFromSerializedRepresentation:(NSDictionary*)serializedRepresentation;

+ (void)setupSerialization;

+ (Class)classForIvar:(Ivar)ivar;

- (id)serializedRepresentation;

@end

@interface BasicSerializedClassesPlaceholder : NSObject
@end

@protocol SerializeByDefault
@end

#define Serialize(propertyName) - (void)serialize_##propertyName {}