#import "Game.h"

@class MovableSpec;
@class CameraComponent;

EntitySpecInterface(CameraSpec, EntitySpec)
{
    MovableSpec* movableSpec;
    CameraComponent* cameraComponent;
}

@end
