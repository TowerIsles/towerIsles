#import "EntityManager.h"
#import "Entity.h"
#import "EntityConfig.h"
#import "EntitySpec.h"
#import "ResourceManager.h"

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

- (void)dealloc
{
	[EntityManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (id)init
{
    if (self = [super init])
    {
        _entitiesByIdentifier = [NSMutableDictionary new];
        _entityConfigsByIdentifier = [NSMutableDictionary new];
    }
    return self;
}

- (void)load
{
    [self internal_setupSpecCaches];
    
    [self loadEntityConfigsFromFile:@"EntityConfig/EntityConfigLibrary.json"];

//    EntitySpec* entity = [self createEntityFromEntityConfigId:@"entityConfig_1"];
//    entity = entity;
}

// Entity Config
- (void)loadEntityConfigsFromFile:(NSString*)filename
{
    NSDictionary* entityConfigDataByEntityConfigId = [ResourceManager configurationForResource:filename];
    
    for (NSString* entityConfigId in entityConfigDataByEntityConfigId)
    {
        CheckTrue([_entityConfigsByIdentifier objectForKey:entityConfigId] == nil);
        
        NSDictionary* entityConfigData = [entityConfigDataByEntityConfigId objectForKey:entityConfigId];
        
        EntityConfig* entityConfig = [EntityConfig objectWithEntityConfigIdentifier:[EntityConfigIdentifier objectWithStringIdentifier:entityConfigId]
                                                       componentDataByComponentType:[entityConfigData objectForKey:@"componentData"]
                                                 orderedBaseEntityConfigIdentifiers:[entityConfigData objectForKey:@"orderedBaseEntityConfigIdentifiers"]];
        
        [_entityConfigsByIdentifier setObject:entityConfig
                                       forKey:entityConfig.identifier];
    }
}

// Entity
- (EntitySpec*)createEntityFromEntityConfigId:(NSString*)entityConfigId
{
    EntityConfigIdentifier* entityConfigIdentifier = [EntityConfigIdentifier objectWithStringIdentifier:entityConfigId];
    
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
        [entity addEntitySpec:conformingEntitySpec];
    }
    
    [entity injectIvarsIntoAllSpecs];
        
    return [entity entitySpecForClass:EntitySpec.class];
}

- (void)queueEntityForRemoval:(EntitySpec*)entityToRemove
{
    //[_entitiesToRemove addObject:entityToRemove.entity];
}

- (EntityIdentifier*)internal_nextEntityIdentifier
{
    return [EntityIdentifier objectWithIntIdentfier:_nextEntityIdentifierIndex++];
}

- (EntityConfig*)entityConfigForEntityConfigIdentifier:(EntityConfigIdentifier*)entityConfigIdentifier
{
    return [_entityConfigsByIdentifier objectForKey:entityConfigIdentifier];
}

- (Entity*)internal_createEntityFromEntityConfigIdentifier:(EntityConfigIdentifier*)entityConfigIdentifier
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
        EntityConfig* entityConfigToAdd = [self entityConfigForEntityConfigIdentifier:[EntityConfigIdentifier objectWithStringIdentifier:entityConfigIdentifierToAdd]];
        
        CheckNotNull(entityConfigToAdd);

        [Util addNewEntriesOfSourceDictionary:entityConfigToAdd.componentDataByComponentType
                           toTargetDictionary:componentConfigurationData];
    }
    
    Entity* entity = [Entity objectWithEntityIdentifier:[self internal_nextEntityIdentifier]
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
- (void)internal_setupSpecCaches
{
    CheckTrue(_allSpecClasses == nil);
    CheckTrue(_conformingEntitySpecClassesByEntityConfigIdentifier == nil);
    
    self.allSpecClasses = [Util allClassesWithSuperClass:EntitySpec.class];
    self.allSpecClasses = [self.allSpecClasses arrayByAddingObject:EntitySpec.class];
    self.conformingEntitySpecClassesByEntityConfigIdentifier = [NSMutableDictionary object];
}

- (NSArray*)specInstancesConformingToSpec:(Class)entitySpecClass
{
    return [_entitySpecsByEntitySpecClass objectForKey:entitySpecClass];
}

@end