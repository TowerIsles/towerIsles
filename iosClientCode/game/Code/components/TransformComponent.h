#import "Game.h"
#import "GameEngine.h"

@interface TransformComponent : Component <SerializeByDefault>

@property (nonatomic, assign) Vec3D location;
@property (nonatomic, assign) Vec3D scale;
@property (nonatomic, assign) Quat rotation;

@end

