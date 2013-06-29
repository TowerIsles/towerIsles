#import "IslandInstance.h"
#import "LandData.h"
#import "EntityManager.h"
#import "SceneManager.h"
#import "SceneNode.h"
#import "Scene.h"
#import "IslandIndex.h"

@interface IslandInstance ()
{
    EntityManager* entityManager;
    SceneManager* sceneManager;
}
@property (nonatomic, retain) NSMutableDictionary* entitySpecsByIdentifier;
@property (nonatomic, retain) IslandData* frostedIslandData;
@property (nonatomic, retain) AppDirector* director;
@property (nonatomic, retain) Scene* scene;
@property (nonatomic, retain) Identifier* sceneIdentifier;
@end

@implementation IslandInstance

+ (IslandInstance*)objectWithDirector:(AppDirector*)director
                           islandData:(IslandData*)islandData
{
    IslandInstance* islandInstance = [IslandInstance object];
    
    islandInstance.director = director;
    
    islandInstance.frostedIslandData = islandData;
    
    [director injectManagersIntoIVars:islandInstance];
    
    return islandInstance;
}

- (void)prepareForEntry
{
    if (_frostedIslandData != nil)
    {
        Scene* previouslyActiveScene = [sceneManager getActiveScene];
        
        self.sceneIdentifier = [Identifier objectWithStringIdentifier:_frostedIslandData.islandIndex.formattedDictionaryKey];
        
        self.scene = [sceneManager createSceneWithIdentifier:_sceneIdentifier
                                                 sceneConfig:_frostedIslandData.sceneConfig];
        
        [sceneManager setActiveScene:_scene];
        
        self.entitySpecsByIdentifier = [NSMutableDictionary object];
        
        for (EntityInstanceConfig* entityInstanceConfig in _frostedIslandData.entityInstanceConfigs)
        {
            CheckNotNull(entityInstanceConfig.orderedBaseEntityConfigIdentifiers);
            CheckNotNull([entityInstanceConfig.orderedBaseEntityConfigIdentifiers objectAtIndex:0]);
            
            [entityInstanceConfig syncIdentifier];
            
            EntitySpec* entitySpec = [entityManager createEntitySpecFromEntityInstanceConfig:entityInstanceConfig];
            
            [_entitySpecsByIdentifier setObject:entitySpec
                                         forKey:entitySpec.entityIdentifier];
        }
        
        [sceneManager setActiveScene:previouslyActiveScene];
        
        self.frostedIslandData = nil;
    }
    
    CheckTrue(_frostedIslandData == nil);
    CheckNotNull(_entitySpecsByIdentifier);
    CheckNotNull(_scene);
    CheckNotNull(_director);
}

@end