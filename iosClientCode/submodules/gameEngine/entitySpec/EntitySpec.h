#import "Base.h"

@class Entity;

@interface EntitySpec : ManagedPropertiesObject

+ (BOOL)doesEntityConformToSpecClass:(Entity*)entity;

- (void)injectFromEntity:(Entity*)entity;

- (id)transformedSpec:(Class)entitySpecClass;

- (id)possiblyTransformedSpec:(Class)entitySpecClass;

@end



#define EntitySpecGettersImplementation(SpecClass)                      \
@implementation EntitySpec (SpecClass)                                  \
                                                                        \
- (SpecClass*)transformedTo##SpecClass                                  \
{                                                                       \
    return [self transformedSpec:objc_getClass(#SpecClass)];            \
}                                                                       \
                                                                        \
- (SpecClass*)possiblyTransformedTo##SpecClass                          \
{                                                                       \
    return [self possiblyTransformedSpec:objc_getClass(#SpecClass)];    \
}                                                                       \
                                                                        \
@end

#define EntitySpecInterface(SpecClass, SuperClass)                      \
@class SpecClass;                                                       \
@interface EntitySpec (SpecClass)                                       \
- (SpecClass*)transformedTo##SpecClass;                                 \
- (SpecClass*)possiblyTransformedTo##SpecClass;                         \
@end                                                                    \
@interface SpecClass : SuperClass
