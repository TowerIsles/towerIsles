#import "Game.h"

@class LoginResponse;
@class PlayerData;
@class CreateNewPlayerResponse;

@interface PlayerManager : Manager

- (void)attemptImplicitLogin;

- (void)createNewPlayerWithLoginId:(NSString*)loginId
                          password:(NSString*)password
                           confirm:(NSString*)confirm
                      successBlock:(void(^)(CreateNewPlayerResponse*))successBlock
                      failureBlock:(VoidBlock)failureBlock;

- (void)loginPlayerWithLoginId:(NSString*)loginId
                      password:(NSString*)password
                  successBlock:(void(^)(LoginResponse*))successBlock
                  failureBlock:(VoidBlock)failureBlock;

- (void)logout;

@end
