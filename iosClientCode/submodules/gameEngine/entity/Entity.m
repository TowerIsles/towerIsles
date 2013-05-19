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
@property (nonatomic, retain) NSMutableDictionary* specInstancesBySpecClass;
@end

@implementation Entity

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
        _specInstancesBySpecClass = [NSMutableDictionary new];
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

- (EntitySpec*)entitySpecForClass:(Class)entitySpec
{
    return [_specInstancesBySpecClass objectForKey:entitySpec];
}

- (void)addEntitySpec:(EntitySpec*)entitySpec
{
    [_specInstancesBySpecClass setObject:entitySpec
                                  forKey:(id<NSCopying>)entitySpec.class];
}

- (void)injectIvarsIntoAllSpecs
{
    for (EntitySpec* spec in _specInstancesBySpecClass.allValues)
    {
        [spec injectFromEntity:self];
    }
}

@end
