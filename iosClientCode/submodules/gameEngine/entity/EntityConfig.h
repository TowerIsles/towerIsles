#import "Base.h"
#import "Identifier.h"

@class DisplayInformation;

@interface EntityConfig : ManagedPropertiesObject
@property (nonatomic, retain, readonly) NSDictionary* componentDataByComponentType;
@property (nonatomic, retain, readonly) NSArray* orderedBaseEntityConfigIdentifiers;
@property (nonatomic, retain, readonly) DisplayInformation* displayInformation;
@property (nonatomic, retain, readonly) Identifier* identifier;

+ (EntityConfig*)objectWithEntityConfigIdentifier:(Identifier*)entityConfigIdentifier
                     componentDataByComponentType:(NSDictionary*)componentDataByComponentType
               orderedBaseEntityConfigIdentifiers:(NSArray*)orderedBaseEntityConfigIdentifiers;

@end
