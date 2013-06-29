#import "Game.h"

@class LandData;
@class IslandData;
@class IslandInstance;
@class IslandIndex;

@interface IslandManager : Manager

- (void)configureWithLandData:(LandData*)landData;

- (IslandInstance*)islandInstanceAtIslandIndex:(IslandIndex*)islandIndex;

- (void)enterIslandInstanceAtIslandIndex:(IslandIndex*)islandIndex;

@end
