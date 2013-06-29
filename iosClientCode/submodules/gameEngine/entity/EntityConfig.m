#import "EntityConfig.h"
#import "DisplayInformation.h"

@interface EntityConfig ()
{
	NSDictionary* _componentDataByComponentType;
    NSArray* _orderedBaseEntityConfigIdentifiers;
    DisplayInformation* _displayInformation;
    Identifier* _identifier;
}

@end

@implementation EntityConfig

+ (void)setupSerialization
{
    [self registerClass:Identifier.class
           forContainer:@"orderedBaseEntityConfigIdentifiers"];
}

- (void)dealloc
{
    [_componentDataByComponentType release];
    [_orderedBaseEntityConfigIdentifiers release];
    [_displayInformation release];
    [_identifier release];
    [super dealloc];
}

- (void)overrideIdentifier:(Identifier*)identifier
{
    [_identifier release];
    _identifier = [identifier retain];
}

+ (EntityConfig*)objectWithEntityConfigIdentifier:(Identifier*)entityConfigIdentifier
                     componentDataByComponentType:(NSDictionary*)componentDataByComponentType
               orderedBaseEntityConfigIdentifiers:(NSArray*)orderedBaseEntityConfigIdentifiers
{
    EntityConfig* entityConfig = [EntityConfig object];
    entityConfig->_identifier = [entityConfigIdentifier retain];
    entityConfig->_componentDataByComponentType = [componentDataByComponentType retain];
    entityConfig->_orderedBaseEntityConfigIdentifiers = [orderedBaseEntityConfigIdentifiers retain];
    return entityConfig;
}

@end

@implementation EntityInstanceConfig

//Serialize(orderedBaseEntityConfigIdentifiers);
//Serialize(displayInformation);
//Serialize(identifier);

- (void)syncIdentifier
{
    [self overrideIdentifier:[self.orderedBaseEntityConfigIdentifiers objectAtIndex:0]];
}

- (NSDictionary*)serializedRepresentationForOfflineDatabase
{
    return [self serializedRepresentation];
//    NSMutableDictionary* output = [self serializedRepresentation];
//    
//    NSMutableArray* entityInstanceConfigsOutput = [NSMutableArray object];
//    
//    componentDataByComponentType
//    
//    for (EntityInstanceConfig* entityInstanceConfig in _entityInstanceConfigs)
//    {
//        [entityInstanceConfigsOutput addObject:[entityInstanceConfig serializedRepresentationForOfflineDatabase]];
//    }
//    
//    [output setObject:entityInstanceConfigsOutput
//               forKey:@"entityInstanceConfigs"];
//    
//    return output;
}

@end
