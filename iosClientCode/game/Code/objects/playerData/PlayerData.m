#import "PlayerData.h"


@interface PlayerData ()
{
	
}
@end


@implementation PlayerData

- (NSDictionary*)serializedRepresentationForOfflineDatabase
{
    return [self serializedRepresentation];
}

@end
