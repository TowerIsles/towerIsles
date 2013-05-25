#import "Vec3D.h"
#import "MathValidation.h"
#import "Asserts.h"

Vec3D Vec3DMakeZero()
{
    return Vec3DMake(0, 0, 0);
}

Vec3D Vec3DMake(float x, float y, float z)
{
    Vec3D ret;
    ret.x = x;
    ret.y = y;
    ret.z = z;
    
    ValidateVec3(ret);
    
    return ret;
}

void Vec3DAdd(Vec3D* v1, const Vec3D* v2) // v1 += v2
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    v1->x += v2->x;
    v1->y += v2->y;
    v1->z += v2->z;
}

Vec3D Vec3DAdded(const Vec3D* v1, const Vec3D* v2) // r = v1 + v2
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    Vec3D ret;
    ret.x = v1->x + v2->x;
    ret.y = v1->y + v2->y;
    ret.z = v1->z + v2->z;
    return ret;
}

void Vec3DSubtract(Vec3D* v1, const Vec3D* v2) // v1 -= v2
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    v1->x -= v2->x;
    v1->y -= v2->y;
    v1->z -= v2->z;
}

Vec3D Vec3DSubtracted(const Vec3D* v1, const Vec3D* v2) // r = v1 - v2
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    Vec3D ret;
    ret.x = v1->x - v2->x;
    ret.y = v1->y - v2->y;
    ret.z = v1->z - v2->z;
    return ret;
}

void Vec3DScale(Vec3D* v1, float scalar) // v1 *= f
{
    ValidateVec3(*v1);
    ValidateFloat(scalar);
    
    v1->x *= scalar;
    v1->y *= scalar;
    v1->z *= scalar;
}

Vec3D Vec3DScaled(const Vec3D* v1, float scalar) // r = v1 * f
{
    ValidateVec3(*v1);
    ValidateFloat(scalar);
    
    Vec3D ret;
    ret.x = v1->x * scalar;
    ret.y = v1->y * scalar;
    ret.z = v1->z * scalar;
    return ret;
}

float Vec3DMagnitude(const Vec3D* v1)
{
    ValidateVec3(*v1);
    
    return sqrtf(Vec3DMagnitudeSquared(v1));
}

float Vec3DMagnitudeSquared(const Vec3D* v1)
{
    ValidateVec3(*v1);
    
    return v1->x * v1->x + v1->y * v1->y + v1->z * v1->z;
}

void Vec3DNormalize(Vec3D* v1)
{
    float mag = Vec3DMagnitude(v1);
    
    CheckTrue(mag != 0);
    
	float oneOverMag = 1.f / mag;
    
    ValidateFloat(oneOverMag);
    
    v1->x *= oneOverMag;
    v1->y *= oneOverMag;
    v1->z *= oneOverMag;
}

Vec3D Vec3DNormalized(const Vec3D* v1)
{
    float mag = Vec3DMagnitude(v1);
    
    CheckTrue(mag != 0);
    
	float oneOverMag = 1.f / mag;
    
    ValidateFloat(oneOverMag);
    
    Vec3D ret;
    ret.x = v1->x * oneOverMag;
    ret.y = v1->y * oneOverMag;
    ret.z = v1->z * oneOverMag;
    return ret;
}

float Vec3DDistance(const Vec3D* v1, const Vec3D* v2)
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    Vec3D result = Vec3DSubtracted(v1, v2);
    return Vec3DMagnitude(&result);
}

BOOL Vec3DIsZero(const Vec3D* v1)
{
    ValidateVec3(*v1);

    return Vec3DMagnitude(v1) == 0;
}

BOOL Vec3DIsNotZero(const Vec3D* v1)
{
    ValidateVec3(*v1);

    return Vec3DMagnitude(v1) != 0;
}

float Vec3DDot(const Vec3D* v1, const Vec3D* v2)
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    return v1->x * v2->x + v1->y * v2->y + v1->z * v2->z;
}

float Vec3DRadianAngleBetween(const Vec3D* v1, const Vec3D* v2)
{
    float dot = Vec3DDot(v1, v2);
    float v1Mag = Vec3DMagnitude(v1);
    float v2Mag = Vec3DMagnitude(v2);
    
    ValidateFloat(dot);
    ValidateFloat(v1Mag);
    ValidateFloat(v2Mag);
    
    CheckTrue(v1Mag * v2Mag != 0);
    
    float cos = dot / (v1Mag * v2Mag);
    
    ValidateFloat(cos);
    ValidateFloat(acosf(cos));
    
    return acosf(cos);
}

Vec3D Vec3DCrossProduct(const Vec3D* v1, const Vec3D* v2)
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    Vec3D ret;
    ret.x = (v1->y * v2->z) - (v2->y * v1->z);
    ret.y = -(v1->x * v2->z) + (v2->x * v1->z);
    ret.z = (v1->x * v2->y) - (v2->x * v1->y);
    return ret;
}

void Vec3DDisplay(const Vec3D* v1)
{
    NSLog(@"Vec3D  x: %f, y: %f, z: %f", v1->x, v1->y, v1->z);
}
