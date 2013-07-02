#import "Base.h"

@interface EntityComponent : ManagedPropertiesObject

- (void)teardown;

- (NSDictionary*)serializedRepresentationForConfigFile;

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end
