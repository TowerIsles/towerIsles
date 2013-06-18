#import "Game.h"

@interface SceneData : ManagedPropertiesObject
@property (nonatomic, retain) NSDictionary* entitiesByIdentifier;

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end

@interface LandData : ManagedPropertiesObject
@property (nonatomic, retain) NSDictionary* sceneDataByIdentifier;

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end
