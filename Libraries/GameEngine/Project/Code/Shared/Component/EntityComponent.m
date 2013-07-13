#import "EntityComponent.h"


@interface EntityComponent ()
{
	
}

@end


@implementation EntityComponent

- (void)teardown {}

- (NSDictionary*)serializedRepresentationForConfigFile
{
    return nil;
}

- (NSDictionary*)serializedRepresentationForOfflineDatabase
{
    return nil;
}

@end
