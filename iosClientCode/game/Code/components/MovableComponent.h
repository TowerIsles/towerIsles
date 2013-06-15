#import "Game.h"

@interface MovableComponent : Component <SerializeByDefault>
@property (nonatomic, retain) SceneNode* sceneNode;
@property (nonatomic, retain) SceneNodeConfig* sceneNodeConfig;
@end
