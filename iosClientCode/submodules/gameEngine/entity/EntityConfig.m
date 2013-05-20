#import "EntityConfig.h"
#import "DisplayInformation.h"

@implementation EntityConfigIdentifier

+ (EntityConfigIdentifier*)objectWithStringIdentifier:(NSString*)stringIdentifier
{
    EntityConfigIdentifier* entityConfigIdentifier = [EntityConfigIdentifier object];
    [entityConfigIdentifier setStringIdentifier:stringIdentifier];
    return entityConfigIdentifier;
}

@end

@interface EntityConfig ()
{
	NSDictionary* _componentDataByComponentType;
    NSArray* _orderedBaseEntityConfigIdentifiers;
    DisplayInformation* _displayInformation;
    EntityConfigIdentifier* _identifier;
}

@end

@implementation EntityConfig

- (void)dealloc
{
    [_componentDataByComponentType release];
    [_orderedBaseEntityConfigIdentifiers release];
    [_displayInformation release];
    [_identifier release];
    [super dealloc];
}

+ (EntityConfig*)objectWithEntityConfigIdentifier:(EntityConfigIdentifier*)entityConfigIdentifier
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

