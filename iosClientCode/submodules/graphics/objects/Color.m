#import "Color.h"

Color ColorMake(float r, float g, float b, float a)
{
    Color ret;
    ret.r = r;
    ret.g = g;
    ret.b = b;
    ret.a = a;
    return ret;
}