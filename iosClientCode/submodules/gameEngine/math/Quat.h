#import "Vec3.h"
#import <GLKit/GLKit.h>

typedef struct Quat {
    float x;
    float y;
    float z;
    float w;
} Quat;

extern const Quat Quat_Zero;
extern const Quat Quat_Identity;

void QuatSet(Quat* q1, const Quat* q2);

void QuatSetIdentity(Quat* q1);

Quat QuatMake(float x, float y, float z, float w);

Quat QuatMakeAxisAngle(const Vec3* axis, float radianAngle);

Quat QuatMakeFromAxes(const Vec3* v1, const Vec3* v2, const Vec3* v3);

Quat QuatMakeFromRotationMatrix(GLKMatrix3* m1);

float QuatMagnitude(const Quat* q1);

float QuatMagnitudeSquared(const Quat* q1);

void QuatNormalize(Quat* q1);

Quat QuatNormalized(const Quat* q1);

void QuatMultiply(Quat* q1, const Quat* q2);

Quat QuatMultiplied(const Quat* q1, const Quat* q2);

void QuatRotateVec3(Vec3* v1, const Quat* q1);

Vec3 QuatRotatedVec3(const Vec3* v1, const Quat* q1);

GLKMatrix3 QuatToMat3(const Quat* q1);

void QuatToAxes(const Quat* q1, Vec3* axes);

void QuatDisplay(NSString* name, const Quat* q1);

#define SerializationHandler_Quat(propertyNameArg, ivarNameArg)      \
- (NSDictionary*)serialize_##propertyNameArg                         \
{                                                                    \
    return Dictionary(@"x", Float(ivarNameArg.x),                    \
                      @"y", Float(ivarNameArg.y),                    \
                      @"z", Float(ivarNameArg.z),                    \
                      @"w", Float(ivarNameArg.w));                   \
}

#define DeserializationHandler_Quat(classArg, propertyNameArg, ivarNameArg)       \
{                                                                                 \
    CheckTrue([self isSubclassOfClass:[classArg class]])                          \
    [self registerDeserializer:^(classArg* instance, NSDictionary* value) {       \
        instance->ivarNameArg.x = [[value objectForKey:@"x"] floatValue];         \
        instance->ivarNameArg.y = [[value objectForKey:@"y"] floatValue];         \
        instance->ivarNameArg.z = [[value objectForKey:@"z"] floatValue];         \
        instance->ivarNameArg.w = [[value objectForKey:@"w"] floatValue];         \
    }                                                                             \
    forProperty:@#propertyNameArg];                                               \
}
