#import "Game.h"

@class MovableSpec;
@class LightComponent;

EntitySpecInterface(LightSpec, EntitySpec)
{
    MovableSpec* movableSpec;
    LightComponent* lightComponent;	
}

@end
