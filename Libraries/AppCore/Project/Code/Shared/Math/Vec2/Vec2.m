#import "Vec2.h"
#import "MathValidation.h"
#import "AppCoreAsserts.h"

const Vec2 Vec2_Zero = {0, 0};
const Vec2 Vec2_UnitX = {1, 0};
const Vec2 Vec2_UnitY = {0, 1};
const Vec2 Vec2_NegativeUnitX = {-1, 0};
const Vec2 Vec2_NegativeUnitY = {0, -1};
const Vec2 Vec2_UnitScale = {1, 1};

void Vec2Set(Vec2* v1, const Vec2* v2)
{
    ValidateVec2(*v1);
    ValidateVec2(*v2);
    v1->x = v2->x;
    v1->y = v2->y;
}

Vec2 Vec2MakeZero()
{
    return Vec2Make(0, 0);
}

Vec2 Vec2Make(float x, float y)
{
    Vec2 ret;
    ret.x = x;
    ret.y = y;
    
    ValidateVec2(ret);
    
    return ret;
}

void Vec2Add(Vec2* v1, const Vec2* v2) // v1 += v2
{
    ValidateVec2(*v1);
    ValidateVec2(*v2);
    
    v1->x += v2->x;
    v1->y += v2->y;
}

Vec2 Vec2Added(const Vec2* v1, const Vec2* v2) // r = v1 + v2
{
    ValidateVec2(*v1);
    ValidateVec2(*v2);
    
    Vec2 ret;
    ret.x = v1->x + v2->x;
    ret.y = v1->y + v2->y;
    return ret;
}

void Vec2Subtract(Vec2* v1, const Vec2* v2) // v1 -= v2
{
    ValidateVec2(*v1);
    ValidateVec2(*v2);
    
    v1->x -= v2->x;
    v1->y -= v2->y;
}

Vec2 Vec2Subtracted(const Vec2* v1, const Vec2* v2) // r = v1 - v2
{
    ValidateVec2(*v1);
    ValidateVec2(*v2);
    
    Vec2 ret;
    ret.x = v1->x - v2->x;
    ret.y = v1->y - v2->y;
    return ret;
}

void Vec2VecScale(Vec2* v1, const Vec2* v2)
{
    ValidateVec2(*v1);
    ValidateVec2(*v2);
    
    v1->x *= v2->x;
    v1->y *= v2->y;
}

Vec2 Vec2VecScaled(Vec2* v1, const Vec2* v2)
{
    ValidateVec2(*v1);
    ValidateVec2(*v2);
    
    Vec2 ret;
    ret.x = v1->x * v2->x;
    ret.y = v1->y * v2->y;
    return ret;
}

void Vec2Scale(Vec2* v1, float scalar) // v1 *= f
{
    ValidateVec2(*v1);
    ValidateFloat(scalar);
    
    v1->x *= scalar;
    v1->y *= scalar;
}

Vec2 Vec2Scaled(const Vec2* v1, float scalar) // r = v1 * f
{
    ValidateVec2(*v1);
    ValidateFloat(scalar);
    
    Vec2 ret;
    ret.x = v1->x * scalar;
    ret.y = v1->y * scalar;
    return ret;
}

float Vec2Magnitude(const Vec2* v1)
{
    ValidateVec2(*v1);
    
    return sqrtf(Vec2MagnitudeSquared(v1));
}

float Vec2MagnitudeSquared(const Vec2* v1)
{
    ValidateVec2(*v1);
    
    return v1->x * v1->x + v1->y * v1->y;
}

void Vec2Normalize(Vec2* v1)
{
    float mag = Vec2Magnitude(v1);
    
    CheckTrue(mag != 0);
    
	float oneOverMag = 1.f / mag;
    
    ValidateFloat(oneOverMag);
    
    v1->x *= oneOverMag;
    v1->y *= oneOverMag;
}

Vec2 Vec2Normalized(const Vec2* v1)
{
    float mag = Vec2Magnitude(v1);
    
    CheckTrue(mag != 0);
    
	float oneOverMag = 1.f / mag;
    
    ValidateFloat(oneOverMag);
    
    Vec2 ret;
    ret.x = v1->x * oneOverMag;
    ret.y = v1->y * oneOverMag;
    return ret;
}

float Vec2Distance(const Vec2* v1, const Vec2* v2)
{
    ValidateVec2(*v1);
    ValidateVec2(*v2);
    
    Vec2 result = Vec2Subtracted(v1, v2);
    return Vec2Magnitude(&result);
}

BOOL Vec2IsZero(const Vec2* v1)
{
    ValidateVec2(*v1);
    
    return Vec2Magnitude(v1) == 0;
}

BOOL Vec2IsNotZero(const Vec2* v1)
{
    ValidateVec2(*v1);
    
    return Vec2Magnitude(v1) != 0;
}

float Vec2Dot(const Vec2* v1, const Vec2* v2)
{
    ValidateVec2(*v1);
    ValidateVec2(*v2);
    
    return v1->x * v2->x + v1->y * v2->y;
}

float Vec2RadianAngleBetween(const Vec2* v1, const Vec2* v2)
{
    return atan2(v2->y, v2->x) - atan2(v1->y, v1->x);
}

void Vec2Display(NSString* name, const Vec2* v1)
{
    NSLog(@"Vec2 : %@\nx: %f\ny: %f", name, v1->x, v1->y);
}

