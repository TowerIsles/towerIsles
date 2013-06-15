#import "Game.h"

@class PlayerData;
@class LandData;

@interface LoginResponse : ManagedPropertiesObject
@property (nonatomic, retain) PlayerData* playerData;
@property (nonatomic, retain) LandData* landData;
@end
