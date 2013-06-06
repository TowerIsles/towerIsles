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

@end
