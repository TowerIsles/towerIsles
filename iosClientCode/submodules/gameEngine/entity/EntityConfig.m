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

+ (EntityConfig*)objectWithEntityConfigIdentifier:(EntityConfigIdentifier*)entityConfigIdentifier
                     componentDataByComponentType:(NSDictionary*)componentDataByComponentType
               orderedBaseEntityConfigIdentifiers:(NSArray*)orderedBaseEntityConfigIdentifiers
{
    EntityConfig* entityConfig = [EntityConfig object];
    entityConfig->_identifier = entityConfigIdentifier;
    entityConfig->_componentDataByComponentType = componentDataByComponentType;
    entityConfig->_orderedBaseEntityConfigIdentifiers = orderedBaseEntityConfigIdentifiers;
    return entityConfig;
}

@end

