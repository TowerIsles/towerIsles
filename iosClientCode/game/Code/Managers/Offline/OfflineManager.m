#import "OfflineManager.h"
#import "AppDirector.h"
#import "LoginResponse.h"
#import "PlayerService.h"
#import "OfflineDatabaseManager.h"

@interface OfflineManager ()
{
	OfflineDatabaseManager* offlineDatabaseManager;
}

@end


@implementation OfflineManager

+ (OfflineManager*)sharedInstance
{
    return (OfflineManager*)[[AppDirector sharedInstance] managerForClass:OfflineManager.class];
}

- (CreateNewPlayerResponse*)createNewPlayerWithLoginId:(NSString*)loginId
                                              password:(NSString*)password
{
    [offlineDatabaseManager createPlayerWithLoginId:loginId
                                           password:password];
    
    CreateNewPlayerResponse* response = [CreateNewPlayerResponse object];
    response.playerData = [offlineDatabaseManager retreivePlayerData:loginId];
    return response;
}

- (LoginResponse*)loginWithLoginId:(NSString*)loginId
                          password:(NSString*)password
{
    LoginResponse* response = [LoginResponse object];
    response.playerData = [offlineDatabaseManager retreivePlayerData:loginId];
    response.landData = [offlineDatabaseManager retreiveLandData:loginId];
    return response;
}

- (void)logout
{
    
}

@end
