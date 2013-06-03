#import "Asserts.h"

struct Color {
    float r;
    float g;
    float b;
    float a;
};
typedef struct Color Color;

Color ColorMake(float r, float g, float b, float a);
unsigned int ColorUnsignedR(Color* color);
unsigned int ColorUnsignedG(Color* color);
unsigned int ColorUnsignedB(Color* color);
unsigned int ColorUnsignedA(Color* color);

#define SerializationHandler_Color(propertyNameArg, ivarNameArg)          \
- (NSDictionary*)serialize_##propertyNameArg                              \
{                                                                         \
    return DictionaryKO(@"r", Float(ivarNameArg.r),                       \
                        @"g", Float(ivarNameArg.g),                       \
                        @"b", Float(ivarNameArg.b),                       \
                        @"a", Float(ivarNameArg.a));                      \
}

#define DeserializationHandler_Color(classArg, propertyNameArg, ivarNameArg)        \
{                                                                                   \
    CheckTrue([self isSubclassOfClass:[classArg class]])                            \
    [self registerDeserializer:^(classArg* instance, NSDictionary* value) {         \
        instance->ivarNameArg.r = [[value objectForKey:@"r"] floatValue];           \
        instance->ivarNameArg.g = [[value objectForKey:@"g"] floatValue];           \
        instance->ivarNameArg.b = [[value objectForKey:@"b"] floatValue];           \
        instance->ivarNameArg.a = [[value objectForKey:@"a"] floatValue];           \
    }                                                                               \
    forProperty:@#propertyNameArg];                                                 \
}