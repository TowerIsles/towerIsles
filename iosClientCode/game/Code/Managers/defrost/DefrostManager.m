#import "DefrostManager.h"
#import "LoginResponse.h"
#import "PlayerData.h"
#import "LandData.h"
#import "IslandManager.h"

@interface DefrostManager ()
{
	IslandManager* islandManager;
}

@end


@implementation DefrostManager

- (void)defrostLoginResponse:(LoginResponse*)loginResponse
{
    PlayerData* playerData = loginResponse.playerData;
    
    LandData* landData = loginResponse.landData;
    
    [islandManager configureWithLandData:landData];
    
    [islandManager enterIslandInstanceAtIslandIndex:playerData.activeIslandIndex];
}

@end
