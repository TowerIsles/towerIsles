#import "Game.h"

@class NodeSpec;
@class RenderableComponent;

EntitySpecInterface(RenderableSpec, EntitySpec)
{
    NodeSpec* nodeSpec;
    RenderableComponent* renderableComponent;
}

@end
