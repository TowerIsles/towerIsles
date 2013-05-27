#import "Game.h"

@interface NodeComponent : Component <SerializeByDefault>
@property (nonatomic, retain) NSMutableArray* sceneNodes;
@property (nonatomic, retain) NSArray* sceneNodeConfigs;
@end
