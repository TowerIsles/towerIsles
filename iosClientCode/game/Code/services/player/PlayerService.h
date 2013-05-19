#import "Game.h"

@class LoginResponse;
@class PlayerData;

@interface CreateNewPlayerRequest : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) NSString* loginId;
@property (nonatomic, retain) NSString* password;
@end

@interface CreateNewPlayerResponse : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) PlayerData* playerData;
@end

@interface LoginRequest : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) NSString* loginId;
@property (nonatomic, retain) NSString* password;
@end

@interface PlayerService : Service

DeclareServiceCommand(createNewPlayer, CreateNewPlayerRequest, CreateNewPlayerResponse)

DeclareServiceCommand(login, LoginRequest, LoginResponse)

DeclareServiceCommandNoInputNoResponse(logout)

@end
