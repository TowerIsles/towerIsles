#import "NSObject+Object.h"

@interface EntityComponent : ManagedPropertiesObject

- (void)teardown;

- (NSDictionary*)serializedRepresentationForConfigFile;

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end
