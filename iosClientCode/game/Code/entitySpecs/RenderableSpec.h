#import "Game.h"

@class MovableSpec;
@class RenderableComponent;

EntitySpecInterface(RenderableSpec, EntitySpec)
{
    MovableSpec* movableSpec;
    RenderableComponent* renderableComponent;
}

@end
