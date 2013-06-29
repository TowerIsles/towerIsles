#import "LandData.h"
#import "EntityConfig.h"

@implementation IslandData

Serialize(islandIndex);
Serialize(sceneConfig);

+ (void)setupSerialization
{
    [self registerClass:EntityInstanceConfig.class
           forContainer:@"entityInstanceConfigs"];
}

- (NSDictionary*)serializedRepresentationForOfflineDatabase
{
    NSMutableDictionary* output = [self serializedRepresentation];
    
    NSMutableArray* entityInstanceConfigsOutput = [NSMutableArray object];
    
    for (EntityInstanceConfig* entityInstanceConfig in _entityInstanceConfigs)
    {
        [entityInstanceConfigsOutput addObject:[entityInstanceConfig serializedRepresentationForOfflineDatabase]];
    }
    
    [output setObject:entityInstanceConfigsOutput
               forKey:@"entityInstanceConfigs"];
    
    return output;
}

@end

@implementation LandData

+ (void)setupSerialization
{
    [self registerClass:IslandData.class
           forContainer:@"islandData"];
}

- (NSDictionary*)serializedRepresentationForOfflineDatabase
{
    NSMutableDictionary* output = [NSMutableDictionary object];
    
    NSMutableArray* islandDataOutput = [NSMutableArray object];
    
    for (IslandData* islandData in _islandData)
    {
        [islandDataOutput addObject:[islandData serializedRepresentationForOfflineDatabase]];
    }
    
    [output setObject:islandDataOutput
               forKey:@"islandData"];
    
    return output;
}

@end
