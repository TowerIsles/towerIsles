#import "Game.h"

@interface PlayerData : ManagedPropertiesObject

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end
