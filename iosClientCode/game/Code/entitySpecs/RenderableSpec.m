#import "RenderableSpec.h"
#import "RenderResourceManager.h"
#import "RenderableComponent.h"
#import "MovableSpec.h"
#import "MovableComponent.h"

@interface RenderableSpec ()
{
    RenderResourceManager* renderResourceManager;
}
@end

@implementation RenderableSpec

- (void)load
{
    Model* model = [Model object];
    
    [model addMesh:[renderResourceManager meshForIdentifier:renderableComponent.renderResourceIdentifier]];
    
    [model addShader:[renderResourceManager shaderForIdentifier:renderableComponent.shaderIdentifier]];
    
    [model addMaterial:[renderResourceManager materialForIdentifier:renderableComponent.materialIdentifier]];
    
    performBlockAfterDelay(0, ^{
        [movableSpec addRenderableToNode:model];
    });
}

@end
