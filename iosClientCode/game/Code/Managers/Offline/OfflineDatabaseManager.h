#import "Game.h"

@class PlayerData;
@class LandData;

@interface OfflineDatabaseManager : Manager

- (void)createPlayerWithLoginId:(NSString*)loginId
                       password:(NSString*)password;

- (void)deleteUserWithLoginId:(NSString*)loginId;

- (PlayerData*)retreivePlayerData:(NSString*)loginId;

- (LandData*)retreiveLandData:(NSString*)loginId;

@end
