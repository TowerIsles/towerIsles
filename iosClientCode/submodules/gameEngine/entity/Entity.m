#import "Entity.h"
#import "EntityConfig.h"
#import "Component.h"
#import "EntitySpec.h"

@implementation EntityIdentifier

+ (EntityIdentifier*)objectWithIntIdentfier:(int64_t)intIdentifier
{
    EntityIdentifier* entityIdentifier = [EntityIdentifier object];
    [entityIdentifier setIntIdentifier:intIdentifier];
    return entityIdentifier;
}

@end

@interface Entity ()
{
    EntityIdentifier* _entityIdentifier;
    EntityConfig* _entityConfig;
}

@property (nonatomic, retain) NSMutableDictionary* componentsByClass;
@property (nonatomic, retain) NSMutableDictionary* entitySpecsByEntitySpecClass;
@end

@implementation Entity

- (void)dealloc
{
    [_entityIdentifier release];
    [_entityConfig release];
    [super dealloc];
}

- (NSString*)description
{
    NSMutableString* description = [NSMutableString object];
    [description appendFormat:@"Entity with identifier = %@\n", _entityIdentifier.stringValue];
    [description appendFormat:@"          entityConfig = %@\n", _entityConfig.identifier.stringValue];
    [description appendFormat:@"===Components===\n\n"];
    
    for (Component* component in _componentsByClass.allValues)
    {
        [description appendFormat:@"%@", component.class];
        [description appendFormat:@"%@\n\n", component.serializedRepresentation];
    }
    
    return description;
}

- (id)init
{
    if (self = [super init])
    {
        _componentsByClass = [NSMutableDictionary new];
        _entitySpecsByEntitySpecClass = [NSMutableDictionary new];
    }
    return self;
}

+ (Entity*)objectWithEntityIdentifier:(EntityIdentifier*)entityIdentifier
                         entityConfig:(EntityConfig*)entityConfig
{
    Entity* entity = [Entity object];
    entity->_entityIdentifier = [entityIdentifier retain];
    entity->_entityConfig = [entityConfig retain];
    return entity;
}

- (Component*)componentForClass:(Class)componentClass
{
    return [_componentsByClass objectForKey:componentClass];
}

- (void)addComponent:(Component*)component
{
    [_componentsByClass setObject:component
                           forKey:(id<NSCopying>)component.class];
}

- (NSArray*)entitySpecClasses
{
    return _entitySpecsByEntitySpecClass.allKeys;
}

- (EntitySpec*)entitySpecForClass:(Class)entitySpec
{
    return [_entitySpecsByEntitySpecClass objectForKey:entitySpec];
}

- (void)addEntitySpec:(EntitySpec*)entitySpec
{
    [_entitySpecsByEntitySpecClass setObject:entitySpec
                                      forKey:(id<NSCopying>)entitySpec.class];
}

- (void)injectIvarsIntoAllSpecs
{
    for (EntitySpec* spec in _entitySpecsByEntitySpecClass.allValues)
    {
        [spec injectFromEntity:self];
    }
}

- (void)teardown
{
    for (EntitySpec* entitySpec in _entitySpecsByEntitySpecClass.allValues)
    {
        [entitySpec teardown];
    }
    [_entitySpecsByEntitySpecClass removeAllObjects];
    self.entitySpecsByEntitySpecClass = nil;
    
    for (Component* component in _componentsByClass.allValues)
    {
        [component teardown];
    }
    [_componentsByClass removeAllObjects];
    self.componentsByClass = nil;
}

@end
