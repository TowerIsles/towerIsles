#import "IslandManager.h"
#import "LandData.h"
#import "IslandIndex.h"
#import "IslandConfig.h"
#import "IslandInstance.h"

@interface IslandManager ()
{
    EntityManager* entityManager;
}
@property (nonatomic, retain) NSMutableDictionary* islandConfigsByIdentifier;
@property (nonatomic, retain) NSMutableDictionary* islandInstancesByIslandIndex;
@end


@implementation IslandManager

+ (void)setupSerialization
{
    [self registerClass:IslandConfig.class
           forContainer:@"islandConfigsByIdentifier"];
}

- (void)load
{
    [self injectConfig:@"ManagerConfig/IslandManagerConfig.json"];
}

- (void)configureWithLandData:(LandData*)landData
{
    self.islandInstancesByIslandIndex = [NSMutableDictionary object];
    
    for (IslandData* islandData in landData.islandData)
    {
        IslandInstance* islandInstance = [IslandInstance objectWithDirector:self.director
                                                                 islandData:islandData];
        
        [_islandInstancesByIslandIndex setObject:islandInstance
                                          forKey:islandData.islandIndex.formattedDictionaryKey];
    }
}

- (IslandInstance*)islandInstanceAtIslandIndex:(IslandIndex*)islandIndex
{
    return [_islandInstancesByIslandIndex objectForKey:islandIndex.formattedDictionaryKey];
}

- (void)enterIslandInstanceAtIslandIndex:(IslandIndex*)islandIndex
{
    CheckNotNull(islandIndex);
    
    IslandInstance* islandInstance = [self islandInstanceAtIslandIndex:islandIndex];
    
    if (islandInstance == nil)
    {
        islandInstance = [self internal_generateIslandInstanceAtIslandIndex:islandIndex];
        
        [_islandInstancesByIslandIndex setObject:islandInstance
                                          forKey:islandIndex.formattedDictionaryKey];
    }
    
    [islandInstance prepareForEntry];
}

- (IslandConfig*)internal_chooseIslandConfigForIslandIndex:(IslandIndex*)islandIndex
{
    Identifier* islandConfigIdentifier = [Identifier objectWithStringIdentifier:@"testIslandConfig"];
    
    return [_islandConfigsByIdentifier objectForKey:islandConfigIdentifier];
}

- (IslandInstance*)internal_generateIslandInstanceAtIslandIndex:(IslandIndex*)islandIndex
{
    IslandConfig* islandConfig = [self internal_chooseIslandConfigForIslandIndex:islandIndex];
    
    return [IslandInstance objectWithDirector:self.director
                                   islandData:[islandConfig generateIslandData]];
}

@end
