#import "NSObject+Object.h"
#import "Node.h"

@class Renderable;

@interface SceneNodeConfig : NodeConfig <SerializeByDefault>
@end

@interface SceneNode : Node

+ (SceneNode*)createRootNode;

- (SceneNode*)createAndAddCameraNodeWithIdentifier:(Identifier*)nodeIdentifier;

- (SceneNode*)createAndAddNodeWithIdentifier:(Identifier*)nodeIdentifier
                             sceneNodeConfig:(SceneNodeConfig*)sceneNodeConfig;

- (void)addRenderable:(Renderable*)renderable;

@end
