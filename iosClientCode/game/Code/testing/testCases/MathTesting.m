#import "MathTesting.h"
#import "Game.h"

@implementation MathTesting

- (void)setup
{
    AddTestCase(@"Vec3 Make", ^BOOL{
        {
            Vec3D v1 = Vec3DMakeZero();
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0);
        }
        {
            Vec3D v1 = Vec3DMake(13567.13567f * 1.2234f, 2.599f, -3.0123f);
            TestCheckTrue(v1.x == 13567.13567f * 1.2234f && v1.y == 2.599f && v1.z == -3.0123f);
        }
        
        return YES;
    });

    AddTestCase(@"Vec3 Adding", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(1, 2, 3);
            
            Vec3D v3 = Vec3DAdded(&v1, &v2);
            
            TestCheckTrue(v1.x == 1 && v1.y == 2 && v1.z == 3);
            TestCheckTrue(v2.x == 1 && v2.y == 2 && v2.z == 3);
            TestCheckTrue(v3.x == 2 && v3.y == 4 && v3.z == 6);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(-1, -2, -3);
            
            Vec3D v3 = Vec3DAdded(&v1, &v2);
            
            TestCheckTrue(v1.x == 1 && v1.y == 2 && v1.z == 3);
            TestCheckTrue(v2.x == -1 && v2.y == -2 && v2.z == -3);
            TestCheckTrue(v3.x == 0 && v3.y == 0 && v3.z == 0);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(1, 2, 3);
            
            Vec3DAdd(&v1, &v2);
            
            TestCheckTrue(v1.x == 2 && v1.y == 4 && v1.z == 6);
            TestCheckTrue(v2.x == 1 && v2.y == 2 && v2.z == 3);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(-1, -2, -3);
            
            Vec3DAdd(&v1, &v2);
            
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0);
            TestCheckTrue(v2.x == -1 && v2.y == -2 && v2.z == -3);
        }
        
        return YES;
    });

    AddTestCase(@"Vec3 Subtract", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(1, 2, 3);
            
            Vec3D v3 = Vec3DSubtracted(&v1, &v2);
            
            TestCheckTrue(v1.x == 1 && v1.y == 2 && v1.z == 3);
            TestCheckTrue(v2.x == 1 && v2.y == 2 && v2.z == 3);
            TestCheckTrue(v3.x == 0 && v3.y == 0 && v3.z == 0);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(-1, -2, -3);
            
            Vec3D v3 = Vec3DSubtracted(&v1, &v2);
            
            TestCheckTrue(v1.x == 1 && v1.y == 2 && v1.z == 3);
            TestCheckTrue(v2.x == -1 && v2.y == -2 && v2.z == -3);
            TestCheckTrue(v3.x == 2 && v3.y == 4 && v3.z == 6);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(1, 2, 3);
            
            Vec3DSubtract(&v1, &v2);
            
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0);
            TestCheckTrue(v2.x == 1 && v2.y == 2 && v2.z == 3);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(-1, -2, -3);
            
            Vec3DSubtract(&v1, &v2);
            
            TestCheckTrue(v1.x == 2 && v1.y == 4 && v1.z == 6);
            TestCheckTrue(v2.x == -1 && v2.y == -2 && v2.z == -3);
        }
        
        return YES;
    });

    AddTestCase(@"Vec3 Scale", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            float scalar = 4;
            
            Vec3D v2 = Vec3DScaled(&v1, scalar);
            
            TestCheckTrue(v1.x == 1 && v1.y == 2 && v1.z == 3);
            TestCheckTrue(v2.x == 4 && v2.y == 8 && v2.z == 12);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            float scalar = -4;
            
            Vec3D v2 = Vec3DScaled(&v1, scalar);
            
            TestCheckTrue(v1.x == 1 && v1.y == 2 && v1.z == 3);
            TestCheckTrue(v2.x == -4 && v2.y == -8 && v2.z == -12);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            float scalar = 4;
            
            Vec3DScale(&v1, scalar);
            
            TestCheckTrue(v1.x == 4 && v1.y == 8 && v1.z == 12);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            float scalar = -4;
            
            Vec3DScale(&v1, scalar);
            
            TestCheckTrue(v1.x == -4 && v1.y == -8 && v1.z == -12);
        }
        return YES;
    });

    AddTestCase(@"Vec3 Magnitude", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(100, 200, 300);
            
            float magnitude = Vec3DMagnitude(&v1);
            
            TestCheckTrue(areFloatsEqual(magnitude, 374.1657f));
        }
        {
            Vec3D v1 = Vec3DMake(99, -99, 2800);
            
            float magnitude = Vec3DMagnitude(&v1);
            
            TestCheckTrue(areFloatsEqual(magnitude, 2803.4981f));
        }
        {
            Vec3D v1 = Vec3DMake(1.001f, .999f, .04f);
            
            float magnitude = Vec3DMagnitude(&v1);
            
            TestCheckTrue(areFloatsEqual(magnitude, 1.4147f));
        }
        {
            Vec3D v1 = Vec3DMake(100, 200, 300);
            
            float magnitudeSquared = Vec3DMagnitudeSquared(&v1);
            
            TestCheckTrue(areFloatsEqual(magnitudeSquared, 374.1657f * 374.1657f));
        }
        {
            Vec3D v1 = Vec3DMake(99, -99, 2800);
            
            float magnitudeSquared = Vec3DMagnitudeSquared(&v1);
            
            TestCheckTrue(areFloatsEqual(magnitudeSquared, 2803.4981f * 2803.4981f));
        }
        {
            Vec3D v1 = Vec3DMake(1.001f, .999f, .04f);
            
            float magnitudeSquared = Vec3DMagnitudeSquared(&v1);
            
            TestCheckTrue(areFloatsEqual(magnitudeSquared, 1.4147f * 1.4147f));
        }
        return YES;
    });
    
    AddTestCase(@"Vec3 Normalize", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(91237.123f, 9183.123f, -1928.12435f);
            
            Vec3D v2 = Vec3DNormalized(&v1);
            
            float magnitude = Vec3DMagnitude(&v2);
            
            TestCheckTrue(v1.x == 91237.123f && v1.y == 9183.123f && v1.z == -1928.12435f);
            TestCheckTrue(areFloatsEqual(magnitude, 1.0f));
        }
        {
            Vec3D v1 = Vec3DMake(12315.1231f, -.123512f, -4.9f);
            
            Vec3D v2 = Vec3DNormalized(&v1);
            
            float magnitude = Vec3DMagnitude(&v2);
            
            TestCheckTrue(v1.x == 12315.1231f && v1.y == -.123512f && v1.z == -4.9f);
            TestCheckTrue(areFloatsEqual(magnitude, 1.0f));
        }
        {
            Vec3D v1 = Vec3DMake(0, 0, .00000000001f);
            
            Vec3D v2 = Vec3DNormalized(&v1);
            
            float magnitude = Vec3DMagnitude(&v2);
            
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == .00000000001f);
            TestCheckTrue(v2.x == 0 && v2.y == 0 && areFloatsEqual(v2.z, 1.0f));
            TestCheckTrue(areFloatsEqual(magnitude, 1.0f));
        }
        
        return YES;
    });
    
    AddTestCase(@"Vec3 Distance", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(0, 0, 0);
            Vec3D v2 = Vec3DMake(0, 1, 0);
            
            float distance = Vec3DDistance(&v1, &v2);
            
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0);
            TestCheckTrue(v2.x == 0 && v2.y == 1 && v2.z == 0);
            TestCheckTrue(distance == 1);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(140, 235, 234);
            
            float distance = Vec3DDistance(&v1, &v2);
            
            TestCheckTrue(v1.x == 1 && v1.y == 2 && v1.z == 3);
            TestCheckTrue(v2.x == 140 && v2.y == 235 && v2.z == 234);
            TestCheckTrue(areFloatsEqual(distance, 356.32990332f));
        }
        {
            Vec3D v1 = Vec3DMake(982.41f, 234.12f, -4123.34f);
            Vec3D v2 = Vec3DMake(987324.234f, -19823.000001f, -987234.00004f);
            
            float distance = Vec3DDistance(&v1, &v2);
            
            TestCheckTrue(v1.x == 982.41f && v1.y == 234.12f && v1.z == -4123.34f);
            TestCheckTrue(v2.x == 987324.234f && v2.y == -19823.000001f && v2.z == -987234.00004f);
            TestCheckTrue(areFloatsEqual(distance, 1392759.506788f));
        }
        return YES;
    });

    AddTestCase(@"Vec3 Is Zero", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(0, 0, 0);
            TestCheckTrue(Vec3DIsZero(&v1));
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0);
            TestCheckTrue(!Vec3DIsNotZero(&v1));
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0);
        }
        {
            Vec3D v1 = Vec3DMake(0.000002f, 0, 0);
            TestCheckTrue(!Vec3DIsZero(&v1));
            TestCheckTrue(v1.x == 0.000002f && v1.y == 0 && v1.z == 0);
            TestCheckTrue(Vec3DIsNotZero(&v1));
            TestCheckTrue(v1.x == 0.000002f && v1.y == 0 && v1.z == 0);
        }
        {
            Vec3D v1 = Vec3DMake(0, 0.000002f, 0);
            TestCheckTrue(!Vec3DIsZero(&v1));
            TestCheckTrue(v1.x == 0 && v1.y == 0.000002f && v1.z == 0);
            TestCheckTrue(Vec3DIsNotZero(&v1));
            TestCheckTrue(v1.x == 0 && v1.y == 0.000002f && v1.z == 0);
        }
        {
            Vec3D v1 = Vec3DMake(0, 0, 0.000002f);
            TestCheckTrue(!Vec3DIsZero(&v1));
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0.000002f);
            TestCheckTrue(Vec3DIsNotZero(&v1));
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0.000002f);
        }
        return YES;
    });
    
    AddTestCase(@"Vec3 Dot", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(0, 0, 0);
            Vec3D v2 = Vec3DMake(0, 0, 0);
            
            float dot = Vec3DDot(&v1, &v2);
            
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0);
            TestCheckTrue(v2.x == 0 && v2.y == 0 && v2.z == 0);
            TestCheckTrue(areFloatsEqual(dot, 0));
        }
        {
            Vec3D v1 = Vec3DMake(2, -3, 2.5f);
            Vec3D v2 = Vec3DMake(.3f, -3.666667f, 4);
            
            float dot = Vec3DDot(&v1, &v2);
            
            TestCheckTrue(v1.x == 2 && v1.y == -3 && v1.z == 2.5f);
            TestCheckTrue(v2.x == .3f && v2.y == -3.666667f && v2.z == 4);
            TestCheckTrue(areFloatsEqual(dot, 21.6f));
        }
        return YES;
    });

    AddTestCase(@"Vec3 Angle Between", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(0, 0, 1);
            Vec3D v2 = Vec3DMake(0, 1, 0);
            
            float angle = Vec3DRadianAngleBetween(&v1, &v2);
            
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 1);
            TestCheckTrue(v2.x == 0 && v2.y == 1 && v2.z == 0);
            TestCheckTrue(areFloatsEqual(angle, M_PI_4));
        }
        {
            Vec3D v1 = Vec3DMake(0, 0, 1);
            Vec3D v2 = Vec3DMake(1, 1, 1);
            
            float angle = Vec3DRadianAngleBetween(&v1, &v2);
            
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 1);
            TestCheckTrue(v2.x == 1 && v2.y == 1 && v2.z == 1);
            TestCheckTrue(areFloatsEqual(angle, 0.955f));
        }
        {
            Vec3D v1 = Vec3DMake(1, -1, 1);
            Vec3D v2 = Vec3DMake(-1, 1, 1);
            
            float angle = Vec3DRadianAngleBetween(&v1, &v2);
            
            TestCheckTrue(v1.x == 1 && v1.y == -1 && v1.z == 1);
            TestCheckTrue(v2.x == -1 && v2.y == 1 && v2.z == 1);
            TestCheckTrue(areFloatsEqual(angle, 1.911f));
        }
        return YES;
    });
    
    AddTestCase(@"Vec3 Cross Product", ^BOOL{
        {
            Vec3D v1 = Vec3DMake(0, 0, 0);
            Vec3D v2 = Vec3DMake(0, 0, 0);
            
            Vec3D v3 = Vec3DCrossProduct(&v1, &v2);
            
            TestCheckTrue(v1.x == 0 && v1.y == 0 && v1.z == 0);
            TestCheckTrue(v2.x == 0 && v2.y == 0 && v2.z == 0);
            TestCheckTrue(v3.x == 0 && v3.y == 0 && v3.z == 0);
        }
        {
            Vec3D v1 = Vec3DMake(1, 2, 3);
            Vec3D v2 = Vec3DMake(3, 4, 5);
            
            Vec3D v3 = Vec3DCrossProduct(&v1, &v2);
            
            TestCheckTrue(v1.x == 1 && v1.y == 2 && v1.z == 3);
            TestCheckTrue(v2.x == 3 && v2.y == 4 && v2.z == 5);
            TestCheckTrue(v3.x == -2 && v3.y == 4 && v3.z == -2);
        }
        {
            Vec3D v1 = Vec3DMake(-1, -2, -3);
            Vec3D v2 = Vec3DMake(3, 4, 5);
            
            Vec3D v3 = Vec3DCrossProduct(&v1, &v2);
            
            TestCheckTrue(v1.x == -1 && v1.y == -2 && v1.z == -3);
            TestCheckTrue(v2.x == 3 && v2.y == 4 && v2.z == 5);
            TestCheckTrue(v3.x == 2 && v3.y == -4 && v3.z == 2);
        }
        {
            Vec3D v1 = Vec3DMake(-1.723f, -2.123f, -3.923f);
            Vec3D v2 = Vec3DMake(3.523f, 4.123f, 5.923f);
            
            Vec3D v3 = Vec3DCrossProduct(&v1, &v2);
                        
            TestCheckTrue(v1.x == -1.723f && v1.y == -2.123f && v1.z == -3.923f);
            TestCheckTrue(v2.x == 3.523f && v2.y == 4.123f && v2.z == 5.923f);
            TestCheckTrue(areFloatsEqual(v3.x, 3.599998f) && areFloatsEqual(v3.y, -3.615399f) && areFloatsEqual(v3.z, 0.375399f));
        }

        
        return YES;
    });
    
    [self run];
}

@end
