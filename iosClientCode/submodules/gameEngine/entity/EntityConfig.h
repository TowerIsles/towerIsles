#import "Base.h"
#import "Identifier.h"

@class DisplayInformation;

@interface EntityConfigIdentifier : Identifier

+ (EntityConfigIdentifier*)objectWithStringIdentifier:(NSString*)stringIdentifier;

@end

@interface EntityConfig : ManagedPropertiesObject
@property (nonatomic, retain, readonly) NSDictionary* componentDataByComponentType;
@property (nonatomic, retain, readonly) NSArray* orderedBaseEntityConfigIdentifiers;
@property (nonatomic, retain, readonly) DisplayInformation* displayInformation;
@property (nonatomic, retain, readonly) EntityConfigIdentifier* identifier;

+ (EntityConfig*)objectWithEntityConfigIdentifier:(EntityConfigIdentifier*)entityConfigIdentifier
                     componentDataByComponentType:(NSDictionary*)componentDataByComponentType
               orderedBaseEntityConfigIdentifiers:(NSArray*)orderedBaseEntityConfigIdentifiers;

@end
