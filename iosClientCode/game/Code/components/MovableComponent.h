#import "Game.h"

@interface MovableComponent : EntityComponent
// Stateful, non-serializable
@property (nonatomic, retain) SceneNode* sceneNode;
// Config, overridable
@property (nonatomic, retain) SceneNodeConfig* sceneNodeConfig;
@end
