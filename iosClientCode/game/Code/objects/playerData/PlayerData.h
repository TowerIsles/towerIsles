#import "Game.h"

@class IslandIndex;

@interface PlayerData : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, retain) IslandIndex* activeIslandIndex;

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end
