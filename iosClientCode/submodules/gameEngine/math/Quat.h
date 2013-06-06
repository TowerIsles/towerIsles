#import "Vec3.h"
#import <GLKit/GLKit.h>

struct Quat {
    float x;
    float y;
    float z;
    float w;
};
typedef struct Quat Quat;

extern const Quat Quat_Zero;
extern const Quat Quat_Identity;

void QuatSet(Quat* q1, const Quat* q2);
void QuatSetIdentity(Quat* q1);
Quat QuatMake(float x, float y, float z, float w);
Quat QuatMakeAxisAngle(const Vec3* axis, float radianAngle);
void QuatMultiply(Quat* q1, const Quat* q2);
Quat QuatMultiplied(const Quat* q1, const Quat* q2);
void QuatRotateVec3(Vec3* v1, const Quat* q1);
Vec3 QuatRotatedVec3(const Vec3* v1, const Quat* q1);
GLKMatrix3 QuatToMat3(const Quat* q1);

void QuatDisplay(const Quat* q1);