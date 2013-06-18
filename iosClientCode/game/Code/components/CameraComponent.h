#import "Game.h"

@class Camera;
@class CameraConfig;

@interface CameraComponent : Component

@property (nonatomic, retain) Camera* camera;
@property (nonatomic, retain) CameraConfig* cameraConfig;

@end
