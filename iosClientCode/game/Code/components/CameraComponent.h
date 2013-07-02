#import "Game.h"

@class Camera;
@class CameraConfig;

@interface CameraComponent : EntityComponent

@property (nonatomic, retain) Camera* camera;
@property (nonatomic, retain) CameraConfig* cameraConfig;

@end
