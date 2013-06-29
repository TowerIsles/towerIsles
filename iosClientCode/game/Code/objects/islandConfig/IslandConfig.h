#import "Game.h"

@class IslandData;

@interface IslandConfigEntity : ManagedPropertiesObject
@property (nonatomic, retain) NSString* entityConfigId;
@property (nonatomic, assign) Vec3 location;
@end

@interface IslandConfig : ManagedPropertiesObject

- (IslandData*)generateIslandData;

@end
