#import "MovableSpec.h"
#import "MovableComponent.h"
#import "SceneManager.h"
#import "SceneNode.h"

EntitySpecGettersImplementation(MovableSpec);

@interface MovableSpec ()
{
    SceneManager* sceneManager;
	MovableComponent* movableComponent;
}

@end

@implementation MovableSpec

- (void)load
{
    SceneNode* sceneNode = [[sceneManager getActiveScene] createAndAddSceneNodeWithIdentifer:[Identifier objectWithNextIdentifier]
                                                                             sceneNodeConfig:movableComponent.sceneNodeConfig
                                                                        parentNodeIdentifier:nil];
    
    movableComponent.sceneNode = sceneNode;
}

- (void)addRenderableToNode:(Renderable*)renderable
{
    [movableComponent.sceneNode addRenderable:renderable];
}

- (void)setPosition:(Vec3)position
{
    Node_setPosition(movableComponent.sceneNode, &position);
}

@end
