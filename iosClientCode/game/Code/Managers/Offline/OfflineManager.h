#import "Game.h"

@class LoginResponse;
@class CreateNewPlayerResponse;

@interface OfflineManager : Manager

+ (OfflineManager*)sharedInstance;


// =================================================
//
//   COMMANDS
//
// =================================================

- (CreateNewPlayerResponse*)createNewPlayerWithLoginId:(NSString*)loginId
                                              password:(NSString*)password;

- (LoginResponse*)loginWithLoginId:(NSString*)loginId
                          password:(NSString*)password;

- (void)logout;

@end
