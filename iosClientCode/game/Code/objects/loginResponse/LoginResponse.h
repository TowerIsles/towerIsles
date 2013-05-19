#import "Game.h"

@class PlayerData;

@interface LoginResponse : ManagedPropertiesObject
@property (nonatomic, retain) PlayerData* playerData;
@end
