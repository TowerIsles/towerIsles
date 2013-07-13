#import "MathValidation.h"

BOOL areFloatsEqual(float f1, float f2)
{
    return abs(f1 - f2) < .000001f;
}