#import "AppCoreUtilities.h"
#import <QuartzCore/QuartzCore.h>

typedef CGPoint Vec2;

extern const Vec2 Vec2_Zero;
extern const Vec2 Vec2_UnitX;
extern const Vec2 Vec2_UnitY;
extern const Vec2 Vec2_NegativeUnitX;
extern const Vec2 Vec2_NegativeUnitY;
extern const Vec2 Vec2_UnitScale;

void Vec2Set(Vec2* v1, const Vec2* v2);

Vec2 Vec2MakeZero();

Vec2 Vec2Make(float x, float y);

void Vec2Add(Vec2* v1, const Vec2* v2);

Vec2 Vec2Added(const Vec2* v1, const Vec2* v2);

void Vec2Subtract(Vec2* v1, const Vec2* v2);

Vec2 Vec2Subtracted(const Vec2* v1, const Vec2* v2);

void Vec2VecScale(Vec2* v1, const Vec2* v2);

Vec2 Vec2VecScaled(Vec2* v1, const Vec2* v2);

void Vec2Scale(Vec2* v1, float scalar);

Vec2 Vec2Scaled(const Vec2* v1, float scalar);

float Vec2Magnitude(const Vec2* v1);

float Vec2MagnitudeSquared(const Vec2* v1);

void Vec2Normalize(Vec2* v1);

Vec2 Vec2Normalized(const Vec2* v1);

float Vec2Distance(const Vec2* v1, const Vec2* v2);

BOOL Vec2IsZero(const Vec2* v1);

BOOL Vec2IsNotZero(const Vec2* v1);

float Vec2Dot(const Vec2* v1, const Vec2* v2);

float Vec2RadianAngleBetween(const Vec2* v1, const Vec2* v2);

void Vec2Display(NSString* name, const Vec2* v1);

#define SerializationHandler_Vec2(propertyNameArg, ivarNameArg)      \
- (NSDictionary*)serialize_##propertyNameArg                         \
{                                                                    \
    return Dictionary(@"x", Float(ivarNameArg.x),                    \
                     @"y", Float(ivarNameArg.y));                    \
}

#define DeserializationHandler_Vec2(classArg, propertyNameArg, ivarNameArg)       \
{                                                                                 \
    CheckTrue([self isSubclassOfClass:[classArg class]])                          \
    [self registerDeserializer:^(classArg* instance, NSDictionary* value) {       \
        instance->ivarNameArg.x = [[value objectForKey:@"x"] floatValue];         \
        instance->ivarNameArg.y = [[value objectForKey:@"y"] floatValue];         \
    }                                                                             \
    forProperty:@#propertyNameArg];                                               \
}
