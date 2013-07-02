#import "PlayerManager.h"
#import "GameUIManager.h"
#import "LoginResponse.h"
#import "PlayerData.h"
#import "PlayerService.h"
#import "SettingsManager.h"
#import "DefrostManager.h"

@interface PlayerManager ()
{
    SettingsManager* settingsManager;
	GameUIManager* gameUIManager;
    DefrostManager* defrostManager;
}
@property (nonatomic, retain) PlayerData* activePlayerData;
@end


@implementation PlayerManager

- (void)reload
{
    self.activePlayerData = nil;
}

- (void)clearUserDefaults
{
    [settingsManager.lastLoginId clearSetting];
    [settingsManager.lastLoginPassword clearSetting];
    [settingsManager.shouldLoginImplicitly clearSetting];
}

- (void)attemptImplicitLogin
{
    CheckTrue([settingsManager.shouldLoginImplicitly getSettingValue])
    
    NSString* lastLoginName = [settingsManager.lastLoginId getSettingValue];
    NSString* lastLoginPassword = [settingsManager.lastLoginPassword getSettingValue];
    
    if (lastLoginName != nil &&
        lastLoginPassword != nil)
    {
        [self loginPlayerWithLoginId:lastLoginName
                            password:lastLoginPassword
                        successBlock:^(LoginResponse* loginResponse) {
                            [defrostManager defrostLoginResponse:loginResponse];
                        }
                        failureBlock:^{
                            [gameUIManager showLoginMenu];
                        }];
    }
    else
    {
        [gameUIManager showLoginMenu];
    }
}

- (BOOL)internal_validateNewUserWithLoginId:(NSString*)loginId
                                   password:(NSString*)password
                                    confirm:(NSString*)confirm
{
    return ![loginId isEqualToString:kDefaultPlayerName] && [password isEqualToString:confirm];
}

- (void)createNewPlayerWithLoginId:(NSString*)loginId
                          password:(NSString*)password
                           confirm:(NSString*)confirm
                      successBlock:(void(^)(CreateNewPlayerResponse*))successBlock
                      failureBlock:(VoidBlock)failureBlock
{
    CreateNewPlayerRequest* request = [CreateNewPlayerRequest object];
    request.loginId  = loginId;
    request.password = password;
    
    if ([self internal_validateNewUserWithLoginId:loginId
                                         password:password
                                          confirm:confirm])
    {
        [PlayerService createNewPlayer:request
                       responseHandler:^(CreateNewPlayerResponse* response) {
                            if (response == nil)
                            {
                                failureBlock();
                            }
                            else
                            {
                                successBlock(response);
                            }
                       }];
    }
    else
    {
        failureBlock();
    }
}

- (void)loginPlayerWithLoginId:(NSString*)loginId
                      password:(NSString*)password
                  successBlock:(void(^)(LoginResponse*))successBlock
                  failureBlock:(VoidBlock)failureBlock
{
    CheckTrue(_activePlayerData == nil);

    if (loginId != nil &&
        ![loginId isEqualToString:kDefaultPlayerName] &&
        password != nil)
    {
        LoginRequest* request = [LoginRequest object];
        request.loginId = loginId;
        request.password = password;
        
        [PlayerService login:request
             responseHandler:^(LoginResponse* response) {
               if (response == nil)
               {
                   [self clearUserDefaults];
                   
                   failureBlock();
               }
               else
               {
                   [settingsManager.lastLoginId setSettingValue:loginId];
                   [settingsManager.lastLoginPassword setSettingValue:password];
                   
                   self.activePlayerData = response.playerData;
                   
                   successBlock(response);
               };
           }];
    }
    else
    {
        [self clearUserDefaults];
        
        failureBlock();
    }
}

- (void)logout
{
    self.activePlayerData = nil;
    
    [PlayerService logout];
}

@end
