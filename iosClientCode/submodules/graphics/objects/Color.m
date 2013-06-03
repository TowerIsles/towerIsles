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

unsigned int ColorUnsignedR(Color* color)
{
    return color->r * 255;
}

unsigned int ColorUnsignedG(Color* color)
{
    return color->g * 255;
}

unsigned int ColorUnsignedB(Color* color)
{
    return color->b * 255;
}

unsigned int ColorUnsignedA(Color* color)
{
    return color->a * 255;
}