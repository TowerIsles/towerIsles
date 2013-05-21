#import "PlayerManager.h"
#import "MenuManager.h"
#import "LoginResponse.h"
#import "PlayerData.h"
#import "PlayerService.h"

@interface PlayerManager ()
{
	MenuManager* menuManager;
}

@property (nonatomic, retain) PlayerData* activePlayerData;

@end


@implementation PlayerManager

- (void)load
{
    
}

- (void)reload
{
    self.activePlayerData = nil;
}

- (void)clearUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaults_lastLoginId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaults_lastLoginPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)internal_setLastLoginId:(NSString*)lastLoginId
              lastLoginPassword:(NSString*)lastLoginPassword
{
    [[NSUserDefaults standardUserDefaults] setObject:lastLoginId
                                              forKey:kUserDefaults_lastLoginId];
    [[NSUserDefaults standardUserDefaults] setObject:lastLoginPassword
                                              forKey:kUserDefaults_lastLoginPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldLoginImplicitly
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_lastLoginId] != nil &&
           [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_lastLoginPassword] != nil;
}

- (void)attemptImplicitLogin
{
    CheckTrue([self shouldLoginImplicitly])
    
    NSString* lastLoginName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_lastLoginId];
    NSString* lastLoginPassword = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_lastLoginPassword];
    
    if (lastLoginName != nil &&
        lastLoginPassword != nil)
    {
        [self loginPlayerWithLoginId:lastLoginName
                            password:lastLoginPassword
                        successBlock:^(LoginResponse* loginResponse) {
                        }
                        failureBlock:^{
                            [menuManager showLoginMenu];
                        }];
    }
}

- (BOOL)internal_validateNewUserWithLoginId:(NSString*)loginId
                                   password:(NSString*)password
                                    confirm:(NSString*)confirm
 {
     return [password isEqualToString:confirm];
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
                            if (response != nil)
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
    LoginRequest* request = [LoginRequest object];
    request.loginId = loginId;
    request.password = password;
    
    if (loginId != nil &&
        password != nil)
    {
        [PlayerService login:request
             responseHandler:^(LoginResponse* response) {
               if (response != nil)
               {
                   [self clearUserDefaults];
                   
                   failureBlock();
               }
               else
               {
                   [self internal_setLastLoginId:loginId
                               lastLoginPassword:password];
                   
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
