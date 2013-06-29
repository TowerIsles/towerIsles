#import "Game.h"

@class IslandIndex;
@class SceneConfig;

@interface IslandData : ManagedPropertiesObject
@property (nonatomic, retain) NSArray* entityInstanceConfigs;
@property (nonatomic, retain) IslandIndex* islandIndex;
@property (nonatomic, retain) SceneConfig* sceneConfig;
@end

@interface LandData : ManagedPropertiesObject
@property (nonatomic, retain) NSArray* islandData;

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end
