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

- (void)dealloc
{
    [_componentDataByComponentType release];
    [_orderedBaseEntityConfigIdentifiers release];
    [_displayInformation release];
    [_identifier release];
    [super dealloc];
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

