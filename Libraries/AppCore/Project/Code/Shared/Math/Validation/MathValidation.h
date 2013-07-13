#import "AppCoreAsserts.h"

#ifdef DEBUG

#define ValidateFloat(floatArg)         \
CheckTrue(!isnan(floatArg));            \
CheckTrue(floatArg != INFINITY);

#define ValidateVec2(vec2Arg)           \
ValidateFloat((vec2Arg).x);             \
ValidateFloat((vec2Arg).y);

#define ValidateVec3(vec3Arg)           \
ValidateFloat((vec3Arg).x);             \
ValidateFloat((vec3Arg).y);             \
ValidateFloat((vec3Arg).z);

#define ValidateQuat(quatArg)           \
ValidateFloat((quatArg).x);             \
ValidateFloat((quatArg).y);             \
ValidateFloat((quatArg).z);             \
ValidateFloat((quatArg).w);             \

#define ValidateMat3(mat3Arg)           \
ValidateFloat(mat3Arg.m00);             \
ValidateFloat(mat3Arg.m01);             \
ValidateFloat(mat3Arg.m02);             \
                                        \
ValidateFloat(mat3Arg.m10);             \
ValidateFloat(mat3Arg.m11);             \
ValidateFloat(mat3Arg.m12);             \
                                        \
ValidateFloat(mat3Arg.m20);             \
ValidateFloat(mat3Arg.m21);             \
ValidateFloat(mat3Arg.m22);         

#define ValidateMat4(mat4Arg)           \
ValidateFloat(mat4Arg.m00);             \
ValidateFloat(mat4Arg.m01);             \
ValidateFloat(mat4Arg.m02);             \
ValidateFloat(mat4Arg.m03);             \
                                        \
ValidateFloat(mat4Arg.m10);             \
ValidateFloat(mat4Arg.m11);             \
ValidateFloat(mat4Arg.m12);             \
ValidateFloat(mat4Arg.m13);             \
                                        \
ValidateFloat(mat4Arg.m20);             \
ValidateFloat(mat4Arg.m21);             \
ValidateFloat(mat4Arg.m22);             \
ValidateFloat(mat4Arg.m23);             \
                                        \
ValidateFloat(mat4Arg.m30);             \
ValidateFloat(mat4Arg.m31);             \
ValidateFloat(mat4Arg.m32);             \
ValidateFloat(mat4Arg.m33);

#else

#define ValidateVec3( X )

#define ValidateFloat( X )

#define ValidateQuat( X )

#define ValidateMat3( X )

#define ValidateMat4( X )

#endif

BOOL areFloatsEqual(float f1, float f2);
