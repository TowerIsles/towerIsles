#import "OfflineManager.h"
#import "GameAppDelegate.h"
#import "LoginResponse.h"
#import "PlayerService.h"
@interface OfflineManager ()
{
	
}

@end


@implementation OfflineManager

- (void)dealloc
{
	[OfflineManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

+ (OfflineManager*)sharedInstance
{
    return (OfflineManager*)[[GameAppDelegate sharedApplicationDelegate].director managerForClass:OfflineManager.class];
}

- (CreateNewPlayerResponse*)createNewPlayerWithLoginId:(NSString*)loginId
                                              password:(NSString*)password
{
    CreateNewPlayerResponse* response = [CreateNewPlayerResponse object];
    return response;
}

- (LoginResponse*)loginWithLoginId:(NSString*)loginId
                          password:(NSString*)password
{
    LoginResponse* response = [LoginResponse object];
    return response;
}

- (void)logout
{
    
}

@end