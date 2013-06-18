#import "Base.h"

@interface Component : ManagedPropertiesObject

- (void)teardown;

- (NSDictionary*)serializedRepresentationForConfigFile;

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end
