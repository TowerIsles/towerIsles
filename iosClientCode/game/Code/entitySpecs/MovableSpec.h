#import "Game.h"

@class MovableComponent;

EntitySpecInterface(MovableSpec, EntitySpec)
{
}

- (void)addRenderableToNode:(Renderable*)renderable;

- (void)setPosition:(Vec3)position;

@end
