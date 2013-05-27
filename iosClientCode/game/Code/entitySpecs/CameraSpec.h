#import "Game.h"

@class NodeSpec;
@class CameraComponent;

EntitySpecInterface(CameraSpec, EntitySpec)
{
    NodeSpec* nodeSpec;
    CameraComponent* cameraComponent;
}

@end
