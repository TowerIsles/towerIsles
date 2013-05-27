#import "Asserts.h"

#ifdef DEBUG

#define ValidateFloat(floatArg)        \
CheckTrue(!isnan(floatArg));           \
CheckTrue(floatArg != INFINITY);

#define ValidateVec3(vec3Arg)          \
ValidateFloat((vec3Arg).x);            \
ValidateFloat((vec3Arg).y);            \
ValidateFloat((vec3Arg).z);

#define ValidateQuat(quatArg)          \
ValidateFloat((quatArg).x);            \
ValidateFloat((quatArg).y);            \
ValidateFloat((quatArg).z);            \
ValidateFloat((quatArg).w);            \

#else

#define ValidateVec3( X )

#define ValidateFloat( X )

#define ValidateQuat( X )

#endif

BOOL areFloatsEqual(float f1, float f2);