#import "EntityManager.h"
#import "Entity.h"
#import "EntityConfig.h"
#import "EntitySpec.h"
#import "ResourceManager.h"
#import "AppDirector.h"

@interface EntityManager ()
{
    
}
// Entity
@property (nonatomic, assign) int64_t nextEntityIdentifierIndex;
@property (nonatomic, retain) NSMutableDictionary* entitiesByIdentifier;
@property (nonatomic, retain) NSMutableDictionary* entityConfigsByIdentifier;
@property (nonatomic, retain) NSMutableArray* entitiesToRemove;

// Entity Spec
@property (nonatomic, retain) NSArray* allSpecClasses;
@property (nonatomic, retain) NSMutableDictionary* conformingEntitySpecClassesByEntityConfigIdentifier;
@property (nonatomic, retain) NSMutableDictionary* entitySpecsByEntitySpecClass;
@end


@implementation EntityManager

- (id)init
{
    if (self = [super init])
    {
        _entitiesToRemove = [NSMutableArray new];
        _entitiesByIdentifier = [NSMutableDictionary new];
        _entityConfigsByIdentifier = [NSMutableDictionary new];
        _entitySpecsByEntitySpecClass = [NSMutableDictionary new];
        _allSpecClasses = [[[Util allClassesWithSuperClass:kEntitySpecClass] arrayByAddingObject:kEntitySpecClass] retain];
        _conformingEntitySpecClassesByEntityConfigIdentifier = [NSMutableDictionary new];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)load
{
    [self.director registerInterUpdateBlock:^{
        [self internal_removeQueuedEntities]; 
    }];
    
    [self loadEntityConfigsFromFile:@"EntityConfig/EntityConfigLibrary_renderables.json"];
    //[self loadEntityConfigsFromFile:@"EntityConfig/EntityConfigLibrary_test.json"];
}

- (void)reload
{
    for (EntitySpec* entitySpec in [self entitySpecInstancesConformingToSpec:kEntitySpecClass])
    {
        [entitySpec queueDestruction];
    }
    [self internal_removeQueuedEntities];
  
#if DEBUG
    CheckTrue(_entitiesToRemove.count == 0);
    CheckTrue(_entitiesByIdentifier.count == 0);
    for (NSMutableArray* entitySpecs in _entitySpecsByEntitySpecClass.allValues)
    {
        CheckTrue(entitySpecs.count == 0);
    }
    CheckTrue(_allSpecClasses.count > 0);
#endif
}

// Entity Config
- (void)loadEntityConfigsFromFile:(NSString*)filename
{
    NSDictionary* entityConfigDataByEntityConfigId = [ResourceManager configurationObjectForResourceInBundleWithName:filename
                                                                                                          usingClass:kDictionaryClass];
    
    for (NSString* entityConfigId in entityConfigDataByEntityConfigId)
    {
        CheckTrue([_entityConfigsByIdentifier objectForKey:[Identifier objectWithStringIdentifier:entityConfigId]] == nil);
        
        NSDictionary* entityConfigData = [entityConfigDataByEntityConfigId objectForKey:entityConfigId];
        
        EntityConfig* entityConfig = [EntityConfig objectWithEntityConfigIdentifier:[Identifier objectWithStringIdentifier:entityConfigId]
                                                       componentDataByComponentType:[entityConfigData objectForKey:@"componentData"]
                                                 orderedBaseEntityConfigIdentifiers:[entityConfigData objectForKey:@"orderedBaseEntityConfigIdentifiers"]];
        
        [_entityConfigsByIdentifier setObject:entityConfig
                                       forKey:entityConfig.identifier];
    }
}

// Entity
- (void)internal_removeQueuedEntities
{
    for (Entity* entity in _entitiesToRemove)
    {
        for (Class specClass in entity.entitySpecClasses)
        {
            NSMutableArray* entitySpecs = [_entitySpecsByEntitySpecClass objectForKey:specClass];
            
            CheckTrue([entitySpecs containsObject:[entity entitySpecForClass:specClass]]);
            
            [entitySpecs removeObject:[entity entitySpecForClass:specClass]];
        }
        
        [entity teardown];
        [_entitiesByIdentifier removeObjectForKey:entity.entityIdentifier];
    }
    
    [_entitiesToRemove removeAllObjects];
}

- (EntitySpec*)createEntitySpecFromEntityConfigId:(NSString*)entityConfigId
{
    Identifier* entityConfigIdentifier = [Identifier objectWithStringIdentifier:entityConfigId];
    
    Entity* entity = [self internal_createEntityFromEntityConfigIdentifier:entityConfigIdentifier];

    NSMutableArray* conformingEntitySpecClasses = [_conformingEntitySpecClassesByEntityConfigIdentifier objectForKey:entity.entityConfig.identifier];
    
    if (conformingEntitySpecClasses == nil)
    {
        conformingEntitySpecClasses = [NSMutableArray object];
        
        [_conformingEntitySpecClassesByEntityConfigIdentifier setObject:conformingEntitySpecClasses
                                                                 forKey:entity.entityConfig.identifier];
        
        for (Class specClass in _allSpecClasses)
        {
            if ([specClass doesEntityConformToSpecClass:entity])
            {
                [conformingEntitySpecClasses addObject:specClass];
            }
        }
    }
    
    for (Class specClass in conformingEntitySpecClasses)
    {
        EntitySpec* conformingEntitySpec = [specClass object];
        
        [self.director injectManagersIntoIVars:conformingEntitySpec];
        
        [entity addEntitySpec:conformingEntitySpec];
        
        NSMutableArray* entitySpecs = [_entitySpecsByEntitySpecClass objectForKey:specClass];
        
        if (entitySpecs == nil)
        {
            entitySpecs = [NSMutableArray object];
            
            [_entitySpecsByEntitySpecClass setObject:entitySpecs
                                              forKey:(id<NSCopying>)specClass];
        }
        
        [entitySpecs addObject:conformingEntitySpec];
    }
    
    [entity injectIvarsIntoAllSpecs];
    
    [entity loadAllSpecs];
        
    return [entity entitySpecForClass:kEntitySpecClass];
}

- (void)queueEntityForRemoval:(Entity*)entityToRemove
{
    [_entitiesToRemove addObject:entityToRemove];
}

- (Identifier*)internal_nextEntityIdentifier
{
    return [Identifier objectWithIntIdentifier:_nextEntityIdentifierIndex++];
}

- (EntityConfig*)entityConfigForEntityConfigIdentifier:(Identifier*)entityConfigIdentifier
{
    return [_entityConfigsByIdentifier objectForKey:entityConfigIdentifier];
}

- (Entity*)internal_createEntityFromEntityConfigIdentifier:(Identifier*)entityConfigIdentifier
{
    EntityConfig* entityConfig = [self entityConfigForEntityConfigIdentifier:entityConfigIdentifier];
    
    CheckNotNull(entityConfig);
    
    return [self internal_createEntityFromEntityConfig:entityConfig];
}

- (Entity*)internal_createEntityFromEntityConfig:(EntityConfig*)entityConfig
{
    CheckNotNull(entityConfig);
 
    NSMutableDictionary* componentConfigurationData = [NSMutableDictionary object];

    [Util addNewEntriesOfSourceDictionary:entityConfig.componentDataByComponentType
                       toTargetDictionary:componentConfigurationData];
    
    for (NSString* entityConfigIdentifierToAdd in entityConfig.orderedBaseEntityConfigIdentifiers)
    {
        EntityConfig* entityConfigToAdd = [self entityConfigForEntityConfigIdentifier:[Identifier objectWithStringIdentifier:entityConfigIdentifierToAdd]];
        
        CheckNotNull(entityConfigToAdd);

        [Util addNewEntriesOfSourceDictionary:entityConfigToAdd.componentDataByComponentType
                           toTargetDictionary:componentConfigurationData];
    }
    
    Entity* entity = [Entity objectWithIdentifier:[self internal_nextEntityIdentifier]
                                     entityConfig:entityConfig];
    
    for (NSString* componentType in componentConfigurationData.allKeys)
    {
        Class componentClass = NSClassFromString(componentType);

        CheckNotNull(componentClass);

        NSDictionary* componentData = [componentConfigurationData objectForKey:componentType];
        
        id component = [componentClass objectFromSerializedRepresentation:componentData];
        
        [entity addComponent:component];
    }
    
    return entity;
}

// Entity Spec
- (NSArray*)entitySpecInstancesConformingToSpec:(Class)entitySpecClass
{
    return [_entitySpecsByEntitySpecClass objectForKey:entitySpecClass];
}

@end
