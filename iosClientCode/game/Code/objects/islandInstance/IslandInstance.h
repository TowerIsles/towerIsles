#import "Game.h"

@class IslandData;

@interface IslandInstance : ManagedPropertiesObject

+ (IslandInstance*)objectWithDirector:(AppDirector*)director
                           islandData:(IslandData*)islandData;

- (void)prepareForEntry;

@end