#import "NSObject+Object.h"
#import "Node.h"

@interface SceneNodeConfig : NodeConfig
@end

@interface SceneNode : Node

- (SceneNode*)createAndAddNodeWithIdentifier:(Identifier*)nodeIdentifier
                             sceneNodeConfig:(SceneNodeConfig*)sceneNodeConfig;

@end
