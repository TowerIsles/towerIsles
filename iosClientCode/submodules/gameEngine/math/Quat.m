#import "Quat.h"
#import "MathValidation.h"

const Quat Quat_Zero = {0, 0, 0, 0};
const Quat Quat_Identity = {0, 0, 0, 1};

void QuatSet(Quat* q1, const Quat* q2)
{
    ValidateQuat(*q1);
    ValidateQuat(*q2);
    
    q1->x = q2->x;
    q1->y = q2->y;
    q1->z = q2->z;
    q1->w = q2->w;
}

void QuatSetIdentity(Quat* q1)
{
    ValidateQuat(*q1);
    
    QuatSet(q1, &Quat_Identity);
}

Quat QuatMake(float x, float y, float z, float w)
{
    ValidateFloat(x);
    ValidateFloat(y);
    ValidateFloat(z);
    ValidateFloat(w);
    
    Quat ret;
    ret.x = x;
    ret.y = y;
    ret.z = z;
    ret.w = w;
    return ret;
}

Quat QuatMakeAxisAngle(const Vec3* axis, float radianAngle)
{
    float halfAngle = radianAngle * .5f;
    float sin = sinf(halfAngle);
    
    Quat ret;
    ret.x = sin * axis->x;
    ret.y = sin * axis->y;
    ret.z = sin * axis->z;
    ret.w = cosf(halfAngle);
    return ret;
}

void QuatMultiply(Quat* q1, const Quat* q2)
{
    float x = q1->w * q2->x + q1->x * q2->w + q1->y * q2->z - q1->z * q2->y;
    float y = q1->w * q2->y + q1->y * q2->w + q1->z * q2->x - q1->x * q2->z;
    float z = q1->w * q2->z + q1->z * q2->w + q1->x * q2->y - q1->y * q2->x;
    float w = q1->w * q2->w - q1->x * q2->x - q1->y * q2->y - q1->z * q2->z;

    q1->x = x;
    q1->y = y;
    q1->z = z;
    q1->w = w;
}

Quat QuatMultiplied(const Quat* q1, const Quat* q2)
{
    Quat ret;
    ret.x = q1->w * q2->x + q1->x * q2->w + q1->y * q2->z - q1->z * q2->y;
    ret.y = q1->w * q2->y + q1->y * q2->w + q1->z * q2->x - q1->x * q2->z;
    ret.z = q1->w * q2->z + q1->z * q2->w + q1->x * q2->y - q1->y * q2->x;
    ret.w = q1->w * q2->w - q1->x * q2->x - q1->y * q2->y - q1->z * q2->z;
    return ret;
}

void QuatDispaly(const Quat* q1)
{
    NSLog(@"Quat  x: %f, y: %f, z: %f, z: %f", q1->x, q1->y, q1->z, q1->w);
}
