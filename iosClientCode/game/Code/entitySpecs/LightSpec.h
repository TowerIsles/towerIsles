#import "Game.h"

@class NodeSpec;
@class LightComponent;

EntitySpecInterface(LightSpec, EntitySpec)
{
    NodeSpec* nodeSpec;
    LightComponent* lightComponent;	
}

@end
