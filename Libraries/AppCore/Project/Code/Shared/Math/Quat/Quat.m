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
    CheckTrue(areFloatsEqual(Vec3Magnitude(axis), 1));
    
    float halfAngle = radianAngle * .5f;
    float sin = sinf(halfAngle);
    
    Quat ret;
    ret.x = sin * axis->x;
    ret.y = sin * axis->y;
    ret.z = sin * axis->z;
    ret.w = cosf(halfAngle);
    return ret;
}

Quat QuatMakeFromAxes(const Vec3* v1, const Vec3* v2, const Vec3* v3)
{
    GLKMatrix3 axesMatrix;
    
    axesMatrix.m00 = v1->x;
    axesMatrix.m10 = v1->y;
    axesMatrix.m20 = v1->z;
    
    axesMatrix.m01 = v2->x;
    axesMatrix.m11 = v2->y;
    axesMatrix.m21 = v2->z;
    
    axesMatrix.m02 = v3->x;
    axesMatrix.m12 = v3->y;
    axesMatrix.m22 = v3->z;
    
    return QuatMakeFromRotationMatrix(&axesMatrix);
}

Quat QuatMakeFromRotationMatrix(GLKMatrix3* m1)
{
    Quat quat;
    
    float trace = m1->m00 + m1->m11 + m1->m22;
    
    if (trace > 0)
    {
        // |w| > 1/2, may as well choose w > 1/2
        float root = sqrtf(trace + 1.0f);  // 2w
        quat.w = 0.5f * root;
        root = 0.5f / root;  // 1/(4w)
        quat.x = (m1->m21 - m1->m12) * root;
        quat.y = (m1->m02 - m1->m20) * root;
        quat.z = (m1->m10 - m1->m01) * root;
    }
    else
    {
        // |w| <= 1/2

        static size_t s_iNext[3] = { 1, 2, 0 };
        size_t i = 0;
        
        float arrayForm[3][3] = { {m1->m00,m1->m01,m1->m02},{m1->m10,m1->m11, m1->m12},{m1->m20,m1->m21,m1->m22} };
        
        if ( m1->m11 > m1->m00 )
            i = 1;
        if ( m1->m22 > arrayForm[i][i] )
            i = 2;
        size_t j = s_iNext[i];
        size_t k = s_iNext[j];
        
        float root = sqrtf(arrayForm[i][i] - arrayForm[j][j] - arrayForm[k][k] + 1.0f);
        float* apkQuat[3] = { &quat.x, &quat.y, &quat.z };
        *apkQuat[i] = 0.5f * root;
        root = 0.5f / root;
        quat.w = (arrayForm[k][j] - arrayForm[j][k]) * root;
        *apkQuat[j] = (arrayForm[j][i] + arrayForm[i][j]) * root;
        *apkQuat[k] = (arrayForm[k][i] + arrayForm[i][k]) * root;
    }
    return quat;
}

float QuatMagnitude(const Quat* q1)
{
    ValidateQuat(*q1);
    
    return sqrtf(QuatMagnitudeSquared(q1));
}

float QuatMagnitudeSquared(const Quat* q1)
{
    ValidateQuat(*q1);
    
    return q1->x * q1->x + q1->y * q1->y + q1->z * q1->z + q1->w * q1->w;
}

void QuatNormalize(Quat* q1)
{
    float mag = QuatMagnitude(q1);
    
    CheckTrue(mag != 0);
    
	float oneOverMag = 1.f / mag;
    
    ValidateFloat(oneOverMag);
    
    q1->x *= oneOverMag;
    q1->y *= oneOverMag;
    q1->z *= oneOverMag;
    q1->w *= oneOverMag;
}

Quat QuatNormalized(const Quat* q1)
{
    float mag = QuatMagnitude(q1);
    
    CheckTrue(mag != 0);
    
	float oneOverMag = 1.f / mag;
    
    ValidateFloat(oneOverMag);
    
    Quat ret;
    ret.x = q1->x * oneOverMag;
    ret.y = q1->y * oneOverMag;
    ret.z = q1->z * oneOverMag;
    ret.w = q1->w * oneOverMag;
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

void QuatRotateVec3(Vec3* v1, const Quat* q1)
{
    *v1 = QuatRotatedVec3(v1, q1);
}

Vec3 QuatRotatedVec3(const Vec3* v1, const Quat* q1)
{
    Vec3 qvec = Vec3Make(q1->x, q1->y, q1->z);
    
    Vec3 uv = Vec3CrossProduct(&qvec, v1);
    
    Vec3 uuv = Vec3CrossProduct(&qvec, &uv);
    
    Vec3Scale(&uv, 2.0f * q1->w);
    
    Vec3Scale(&uuv, 2.0f);
    
    Vec3Add(&uuv, &uv);
    
    return  Vec3Added(v1, &uuv);
}

GLKMatrix3 QuatToMat3(const Quat* q1)
{
    float x = q1->x;
    float y = q1->y;
    float z = q1->z;
    float w = q1->w;
    float fTx  = x + x;
    float fTy  = y + y;
    float fTz  = z + z;
    float fTwx = fTx * w;
    float fTwy = fTy * w;
    float fTwz = fTz * w;
    float fTxx = fTx * x;
    float fTxy = fTy * x;
    float fTxz = fTz * x;
    float fTyy = fTy * y;
    float fTyz = fTz * y;
    float fTzz = fTz * z;
    
    return GLKMatrix3Make(1.0f - (fTyy + fTzz),
                          fTxy - fTwz,
                          fTxz + fTwy,
                          fTxy + fTwz,
                          1.0f - (fTxx + fTzz),
                          fTyz - fTwx,
                          fTxz - fTwy,
                          fTyz + fTwx,
                          1.0f - (fTxx + fTyy));
}

void QuatToAxes(const Quat* q1, Vec3* axes)
{
    GLKMatrix3 rotationMatrix = QuatToMat3(q1);
    
    axes[0].x = rotationMatrix.m00;
    axes[0].y = rotationMatrix.m10;
    axes[0].z = rotationMatrix.m20;
    
    axes[1].x = rotationMatrix.m01;
    axes[1].y = rotationMatrix.m11;
    axes[1].z = rotationMatrix.m21;
    
    axes[2].x = rotationMatrix.m02;
    axes[2].y = rotationMatrix.m12;
    axes[2].z = rotationMatrix.m22;
    
//    for (int column = 0; column < 3; column++)
//    {
//        akAxis[iCol].x = kRot[0][column];
//        akAxis[iCol].y = kRot[1][column];
//        akAxis[iCol].z = kRot[2][column];
//    }
}

void QuatDisplay(NSString* name, const Quat* q1)
{
    NSLog(@"Quat : %@\nx: %f\ny: %f\nz: %f\nw: %f", name, q1->x, q1->y, q1->z, q1->w);
}
