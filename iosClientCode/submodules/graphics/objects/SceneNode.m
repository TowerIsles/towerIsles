#import "SceneNode.h"
#import "Asserts.h"

@implementation SceneNodeConfig
@end

@interface SceneNode ()
{
	
}

@end


@implementation SceneNode

- (SceneNode*)createAndAddNodeWithIdentifier:(Identifier*)nodeIdentifier
                             sceneNodeConfig:(SceneNodeConfig*)sceneNodeConfig
{
    CheckNotNull(nodeIdentifier);
    CheckNotNull(sceneNodeConfig);
    
    SceneNode* child = [SceneNode object];

    [child configureWithIdentifier:nodeIdentifier
                        nodeConfig:sceneNodeConfig];
    
    [self addChildNode:child];
    
    return child;
}


@end
