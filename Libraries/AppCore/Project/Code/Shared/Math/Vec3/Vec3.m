#import "Vec3.h"
#import "MathValidation.h"
#import "AppCoreAsserts.h"
#import "Quat.h"

const Vec3 Vec3_Zero = {0, 0, 0};
const Vec3 Vec3_UnitX = {1, 0, 0};
const Vec3 Vec3_UnitY = {0, 1, 0};
const Vec3 Vec3_UnitZ = {0, 0, 1};
const Vec3 Vec3_NegativeUnitX = {-1, 0, 0};
const Vec3 Vec3_NegativeUnitY = {0, -1, 0};
const Vec3 Vec3_NegativeUnitZ = {0, 0, -1};
const Vec3 Vec3_UnitScale = {1, 1, 1};

void Vec3Set(Vec3* v1, const Vec3* v2)
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    v1->x = v2->x;
    v1->y = v2->y;
    v1->z = v2->z;
}

Vec3 Vec3MakeZero()
{
    return Vec3Make(0, 0, 0);
}

Vec3 Vec3Make(float x, float y, float z)
{
    Vec3 ret;
    ret.x = x;
    ret.y = y;
    ret.z = z;
    
    ValidateVec3(ret);
    
    return ret;
}

void Vec3Add(Vec3* v1, const Vec3* v2) // v1 += v2
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    v1->x += v2->x;
    v1->y += v2->y;
    v1->z += v2->z;
}

Vec3 Vec3Added(const Vec3* v1, const Vec3* v2) // r = v1 + v2
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    Vec3 ret;
    ret.x = v1->x + v2->x;
    ret.y = v1->y + v2->y;
    ret.z = v1->z + v2->z;
    return ret;
}

void Vec3Subtract(Vec3* v1, const Vec3* v2) // v1 -= v2
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    v1->x -= v2->x;
    v1->y -= v2->y;
    v1->z -= v2->z;
}

Vec3 Vec3Subtracted(const Vec3* v1, const Vec3* v2) // r = v1 - v2
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    Vec3 ret;
    ret.x = v1->x - v2->x;
    ret.y = v1->y - v2->y;
    ret.z = v1->z - v2->z;
    return ret;
}

void Vec3VecScale(Vec3* v1, const Vec3* v2)
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    v1->x *= v2->x;
    v1->y *= v2->y;
    v1->z *= v2->z;
}

Vec3 Vec3VecScaled(Vec3* v1, const Vec3* v2)
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    Vec3 ret;
    ret.x = v1->x * v2->x;
    ret.y = v1->y * v2->y;
    ret.z = v1->z * v2->z;
    return ret;
}

void Vec3Scale(Vec3* v1, float scalar) // v1 *= f
{
    ValidateVec3(*v1);
    ValidateFloat(scalar);
    
    v1->x *= scalar;
    v1->y *= scalar;
    v1->z *= scalar;
}

Vec3 Vec3Scaled(const Vec3* v1, float scalar) // r = v1 * f
{
    ValidateVec3(*v1);
    ValidateFloat(scalar);
    
    Vec3 ret;
    ret.x = v1->x * scalar;
    ret.y = v1->y * scalar;
    ret.z = v1->z * scalar;
    return ret;
}

float Vec3Magnitude(const Vec3* v1)
{
    ValidateVec3(*v1);
    
    return sqrtf(Vec3MagnitudeSquared(v1));
}

float Vec3MagnitudeSquared(const Vec3* v1)
{
    ValidateVec3(*v1);
    
    return v1->x * v1->x + v1->y * v1->y + v1->z * v1->z;
}

void Vec3Normalize(Vec3* v1)
{
    float mag = Vec3Magnitude(v1);
    
    CheckTrue(mag != 0);
    
	float oneOverMag = 1.f / mag;
    
    ValidateFloat(oneOverMag);
    
    v1->x *= oneOverMag;
    v1->y *= oneOverMag;
    v1->z *= oneOverMag;
}

Vec3 Vec3Normalized(const Vec3* v1)
{
    float mag = Vec3Magnitude(v1);
    
    CheckTrue(mag != 0);
    
	float oneOverMag = 1.f / mag;
    
    ValidateFloat(oneOverMag);
    
    Vec3 ret;
    ret.x = v1->x * oneOverMag;
    ret.y = v1->y * oneOverMag;
    ret.z = v1->z * oneOverMag;
    return ret;
}

float Vec3Distance(const Vec3* v1, const Vec3* v2)
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    Vec3 result = Vec3Subtracted(v1, v2);
    return Vec3Magnitude(&result);
}

BOOL Vec3IsZero(const Vec3* v1)
{
    ValidateVec3(*v1);

    return Vec3Magnitude(v1) == 0;
}

BOOL Vec3IsNotZero(const Vec3* v1)
{
    ValidateVec3(*v1);

    return Vec3Magnitude(v1) != 0;
}

float Vec3Dot(const Vec3* v1, const Vec3* v2)
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    return v1->x * v2->x + v1->y * v2->y + v1->z * v2->z;
}

float Vec3RadianAngleBetween(const Vec3* v1, const Vec3* v2)
{
    float dot = Vec3Dot(v1, v2);
    float v1Mag = Vec3Magnitude(v1);
    float v2Mag = Vec3Magnitude(v2);
    
    ValidateFloat(dot);
    ValidateFloat(v1Mag);
    ValidateFloat(v2Mag);
    
    CheckTrue(v1Mag * v2Mag != 0);
    
    float cos = dot / (v1Mag * v2Mag);
    
    ValidateFloat(cos);
    ValidateFloat(acosf(cos));
    
    return acosf(cos);
}

Vec3 Vec3CrossProduct(const Vec3* v1, const Vec3* v2)
{
    ValidateVec3(*v1);
    ValidateVec3(*v2);
    
    Vec3 ret;
    ret.x = (v1->y * v2->z) - (v2->y * v1->z);
    ret.y = -(v1->x * v2->z) + (v2->x * v1->z);
    ret.z = (v1->x * v2->y) - (v2->x * v1->y);
    return ret;
}

void Vec3Display(NSString* name, const Vec3* v1)
{
    NSLog(@"Vec3 : %@\nx: %f\ny: %f\nz: %f", name, v1->x, v1->y, v1->z);
}

Quat Vec3RotationTo(const Vec3* v1, const Vec3* v2)
{
    CheckTrue(Vec3IsNotZero(v1));
    CheckTrue(Vec3IsNotZero(v2));
    
    Vec3 source = Vec3Normalized(v1);
    Vec3 destination = Vec3Normalized(v2);
    
    float dot = Vec3Dot(&source, &destination);
    
    if (dot >= 1.0f)
    {
        return Quat_Identity;
    }
    else if (dot < (1e-6f - 1.0f))
    {
        // Generate an axis
        Vec3 axis = Vec3CrossProduct(&Vec3_UnitX, v1);
        
        if (Vec3IsZero(&axis))
        {
            axis = Vec3CrossProduct(&Vec3_UnitY, v1);
        }
        
        Vec3Normalize(&axis);
        
        return QuatMakeAxisAngle(&axis, M_PI);
    }
    else
    {
        float s = sqrtf((1.0f + dot) * 2.0f);
        float inverse = 1.0f / s;
        
        Vec3 cross = Vec3CrossProduct(&source, &destination);
        
        Quat quat = QuatMake(cross.x * inverse, cross.y * inverse, cross.z * inverse, s * .5f);
        
        return QuatNormalized(&quat);
    }
}
