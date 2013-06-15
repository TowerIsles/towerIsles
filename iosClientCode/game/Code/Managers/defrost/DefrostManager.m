#import "DefrostManager.h"
#import "LoginResponse.h"
#import "PlayerData.h"
#import "LandData.h"

@interface DefrostManager ()
{
	
}

@end


@implementation DefrostManager

- (void)defrostLoginResponse:(LoginResponse*)loginResponse
{
    PlayerData* playerData = loginResponse.playerData;
    LandData* landData = loginResponse.landData;
    
    // create entities
    // record player data in playermanager? may or may not need - may have been done on login
    
}

@end
