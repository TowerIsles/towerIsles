#import "Game.h"

@class Camera;
@class CameraConfig;

@interface CameraComponent : Component <SerializeByDefault>

@property (nonatomic, retain) Camera* camera;
@property (nonatomic, retain) CameraConfig* cameraConfig;
@property (nonatomic, assign) int nodeIndex;

@end
