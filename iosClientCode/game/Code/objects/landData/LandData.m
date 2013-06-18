#import "LandData.h"
#import "Entity.h"

@implementation SceneData

+ (void)setupSerialization
{
    [self registerClass:Entity.class // this doesn't make sense - component configs maybe? not sure yet.
           forContainer:@"entitiesByIdentifier"];
}

- (NSDictionary*)serializedRepresentationForOfflineDatabase
{
    NSMutableDictionary* output = [NSMutableDictionary object];
    
    for (Identifier* entityIdentifier in [_entitiesByIdentifier allKeys])
    {
        Entity* entity = [_entitiesByIdentifier objectForKey:entityIdentifier];
        
        [output setObject:[entity serializedRepresentationForOfflineDatabase]
                   forKey:entityIdentifier];
    }
    
    return output;
}

@end


@implementation LandData

- (NSDictionary*)serializedRepresentationForOfflineDatabase
{
    NSMutableDictionary* output = [NSMutableDictionary object];
    
    for (Identifier* sceneIdentifier in [_sceneDataByIdentifier allKeys])
    {
        SceneData* sceneData = [_sceneDataByIdentifier objectForKey:sceneIdentifier];
        
        [output setObject:[sceneData serializedRepresentationForOfflineDatabase]
                   forKey:sceneIdentifier];
    }
    
    return output;
}

@end
