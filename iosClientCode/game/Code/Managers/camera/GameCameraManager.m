#import "GameCameraManager.h"

@interface GameCameraManager ()
{
    TouchManager* touchManager;
    ViewManager* viewManager;
    SceneManager* sceneManager;
}
@property (nonatomic, retain) TouchChannel* touchChannel;
@end


@implementation GameCameraManager

- (void)load
{
    TouchChannelConfig* touchChannelConfig = [TouchChannelConfig object];
    
//    touchChannelConfig.observeTap = YES;
    touchChannelConfig.observeLongPress = YES;
    touchChannelConfig.observePan = YES;
    touchChannelConfig.observePinch = YES;
    
    self.touchChannel = [touchManager createTouchChannelForView:(UIView*)viewManager.getGLKView
                                                     withConfig:touchChannelConfig];
    
    [self.director registerUpdateBlock:^{
        [self update];
    }];
}

- (void)update
{
    if (_touchChannel.longPressGesture.isActive)
    {
        SceneNode* cameraOneNode = [[sceneManager getActiveScene] cameraOneNode];
        Camera* activeCamera = [[sceneManager getActiveScene] getActiveCamera];
        
        Vec3 newPosition = Vec3Make(0, 0, -1);
        Node_setPosition(cameraOneNode, &newPosition);
        [activeCamera lookAt:Vec3_Zero];
    }
    if (_touchChannel.panGesture.isActive)
    {
        SceneNode* cameraOneNode = [[sceneManager getActiveScene] cameraOneNode];
        //Camera* activeCamera = [[sceneManager getActiveScene] getActiveCamera];
        Vec3 currentPosition = Node_getPosition(cameraOneNode);
        float radianAngle = .1f;
        float maxXVelocity = 400.0f;
        float maxYVelocity = 400.0f;
        float horizontalAngleCoefficient = MIN(maxXVelocity, fabs(_touchChannel.panGesture.velocityInView.x)) / maxXVelocity;
        float verticalAngleCoefficient = MIN(maxYVelocity, fabs(_touchChannel.panGesture.velocityInView.y)) / maxYVelocity;
        Quat rotationRight = QuatMakeAxisAngle(&Vec3_UnitY, radianAngle * horizontalAngleCoefficient);
        Quat rotationLeft = QuatMakeAxisAngle(&Vec3_UnitY, -radianAngle * horizontalAngleCoefficient);
        Quat rotationUp = QuatMakeAxisAngle(&Vec3_UnitX, radianAngle * verticalAngleCoefficient);
        Quat rotationDown = QuatMakeAxisAngle(&Vec3_UnitX, -radianAngle * verticalAngleCoefficient);
        Vec3 newPosition = currentPosition;
        
        
        BOOL changeOccurred = NO;
        
        if (fabs(_touchChannel.panGesture.velocityInView.x) > 0)
        {
            if (_touchChannel.panGesture.velocityInView.x < 0)
            {
                newPosition = QuatRotatedVec3(&currentPosition, &rotationLeft);
            }
            else
            {
                newPosition = QuatRotatedVec3(&currentPosition, &rotationRight);
            }
            
            changeOccurred = YES;
        }
        if (fabs(_touchChannel.panGesture.velocityInView.y) > 0)
        {
            if (_touchChannel.panGesture.velocityInView.y > 0)
            {
                newPosition = QuatRotatedVec3(&newPosition, &rotationUp);
            }
            else
            {
                newPosition = QuatRotatedVec3(&newPosition, &rotationDown);
            }
            
            changeOccurred = YES;
        }
        
        if (changeOccurred)
        {
            Node_setPosition(cameraOneNode, &newPosition);
        }
    }
    if (_touchChannel.pinchGesture.isActive)
    {
        float scale = _touchChannel.pinchGesture.velocity;

        SceneNode* cameraOneNode = [[sceneManager getActiveScene] cameraOneNode];
        
        Vec3 currentPosition = Node_getPosition(cameraOneNode);

        if (Vec3IsZero(&currentPosition))
        {
            currentPosition = Vec3Make(0, 0, .01f);
        }
        
        BOOL negX = currentPosition.x < 0;
        BOOL negY = currentPosition.y < 0;
        BOOL negZ = currentPosition.z < 0;

        Vec3 normalizedCurrentPosition = Vec3Normalized(&currentPosition);
        Vec3Scale(&normalizedCurrentPosition, scale);
        Vec3 newPosition = Vec3Added(&currentPosition, &normalizedCurrentPosition);
        
        if ((negX && (newPosition.x > 0)) ||
            (negX && (newPosition.x < 0)))
        {
            newPosition.x = 0;
        }
        if ((negY && (newPosition.y > 0)) ||
            (negY && (newPosition.y < 0)))
        {
            newPosition.y = 0;
        }
        if ((negZ && (newPosition.z > 0)) ||
            (negZ && (newPosition.z < 0)))
        {
            newPosition.z = 0;
        }
        
        Node_setPosition(cameraOneNode, &newPosition);
    }
}

@end
