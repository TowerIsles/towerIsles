#import "PlayerService.h"
#import "LoginResponse.h"
#import "OfflineManager.h"

@implementation CreateNewPlayerRequest
@end

@implementation CreateNewPlayerResponse
@end

@implementation LoginRequest
@end

@implementation PlayerService

ServiceName(PlayerService);

GameServiceCommand(createNewPlayer, CreateNewPlayerRequest, CreateNewPlayerResponse, ^(CreateNewPlayerRequest* request) {
    return [[OfflineManager sharedInstance] createNewPlayerWithLoginId:request.loginId
                                                              password:request.password];
});


GameServiceCommand(login, LoginRequest, LoginResponse, ^(LoginRequest* request) {
    return [[OfflineManager sharedInstance] loginWithLoginId:request.loginId
                                                    password:request.password];
});

GameServiceCommandNoInputNoResponse(logout, ^{
    [[OfflineManager sharedInstance] logout];
});

@end

