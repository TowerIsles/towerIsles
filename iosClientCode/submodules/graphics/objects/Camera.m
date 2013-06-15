#import "Camera.h"
#import "Node.h"
#import "GraphicsBase.h"

@implementation CameraConfig
@end

@interface Camera ()
{
	
}
@property (nonatomic, assign) GLKMatrix4 viewMatrix;
@end


@implementation Camera

- (void)internal_calculateViewMatrix
{
    Vec3 position = Node_getPosition(self.node);
    
    Quat orientation = Node_getOrientation(self.node);
    
    GLKMatrix3 rotation = QuatToMat3(&orientation);
    
    rotation = GLKMatrix3Transpose(rotation);
    
    GLKVector3 translation = GLKMatrix3MultiplyVector3(rotation, GLKVector3Make(position.x, position.y, position.z));
    
    GLKMatrix4* viewMatrix = &_viewMatrix;
    
    viewMatrix->m00 = rotation.m00;
    viewMatrix->m01 = rotation.m01;
    viewMatrix->m02 = rotation.m02;
    viewMatrix->m03 = 0;
    
    viewMatrix->m10 = rotation.m10;
    viewMatrix->m11 = rotation.m11;
    viewMatrix->m12 = rotation.m12;
    viewMatrix->m13 = 0;
    
    viewMatrix->m20 = rotation.m20;
    viewMatrix->m21 = rotation.m21;
    viewMatrix->m22 = rotation.m22;
    viewMatrix->m23 = 0;
    
    viewMatrix->m30 = -translation.x;
    viewMatrix->m31 = -translation.y;
    viewMatrix->m32 = -translation.z;
    viewMatrix->m33 = 1;
}

- (GLKMatrix4*)getViewMatrix
{
    [self internal_calculateViewMatrix];
    
    return &_viewMatrix;
}

- (void)lookAt:(Vec3)targetLocation
{
    Vec3 nodePosition = Node_getPosition(self.node);
    //Vec3Display(@"nodePosition", &nodePosition);
    [self setDirection:Vec3Subtracted(&targetLocation, &nodePosition)];
}

- (void)setDirection:(Vec3)direction
{
    CheckTrue(Vec3IsNotZero(&direction));
    
    //Vec3Scale(&direction, -1);
    Vec3Normalize(&direction);
    
    Quat currentWorldOrientation = Node_getOrientation(self.node);
    Quat rotationTo;
    Quat targetWorldOrientation;
    
    if (YES)
    {
        Vec3 xVec = Vec3CrossProduct(&Vec3_UnitY, &direction);
        Vec3Normalize(&xVec);
        
        Vec3 yVec = Vec3CrossProduct(&direction, &xVec);
        Vec3Normalize(&yVec);
        
        targetWorldOrientation = QuatMakeFromAxes(&xVec, &yVec, &direction);
    }
    else
    {
        Vec3 axes[3];
        
        QuatToAxes(&currentWorldOrientation, axes);
        
        Vec3 temp = Vec3Added(&axes[1], &direction);
        
        if (Vec3MagnitudeSquared(&temp) < 0.00005f)
        {
            rotationTo = QuatMakeAxisAngle(&axes[1], M_PI);
        }
        else
        {
            rotationTo = Vec3RotationTo(&axes[2], &direction);
        }
        
        targetWorldOrientation = QuatMultiplied(&rotationTo, &currentWorldOrientation);
    }
    QuatNormalize(&targetWorldOrientation);

    Node_setOrientation(self.node, &targetWorldOrientation);
}

@end
