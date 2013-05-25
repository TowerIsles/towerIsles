#import "Asserts.h"

#ifdef DEBUG

#define ValidateFloat(floatArg)        \
CheckTrue(!isnan(floatArg));           \
CheckTrue(floatArg != INFINITY);

#define ValidateVec3(vec3Arg)          \
ValidateFloat((vec3Arg).x);            \
ValidateFloat((vec3Arg).y);            \
ValidateFloat((vec3Arg).z);

#else

#define ValidateVec3( X )

#define ValidateFloat( X )

#endif

BOOL areFloatsEqual(float f1, float f2);