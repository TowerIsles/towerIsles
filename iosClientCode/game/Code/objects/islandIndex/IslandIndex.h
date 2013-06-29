#import "Game.h"

@interface IslandIndex : ManagedPropertiesObject<SerializeByDefault>

+ (IslandIndex*)objectWithX:(int)x
                          y:(int)y;

- (NSString*)formattedDictionaryKey;

@end
