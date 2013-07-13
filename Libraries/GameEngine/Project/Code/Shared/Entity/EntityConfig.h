#import "AppCore.h"
#import "Identifier.h"

@class DisplayInformation;

@interface EntityConfig : ManagedPropertiesObject<SerializeByDefault>
@property (nonatomic, retain, readonly) NSDictionary* componentDataByComponentType;
@property (nonatomic, retain, readonly) NSArray* orderedBaseEntityConfigIdentifiers;
@property (nonatomic, retain, readonly) DisplayInformation* displayInformation;
@property (nonatomic, retain, readonly) Identifier* identifier;

+ (EntityConfig*)objectWithEntityConfigIdentifier:(Identifier*)entityConfigIdentifier
                     componentDataByComponentType:(NSDictionary*)componentDataByComponentType
               orderedBaseEntityConfigIdentifiers:(NSArray*)orderedBaseEntityConfigIdentifiers;

@end

@interface EntityInstanceConfig : EntityConfig<SerializeByDefault>

- (void)syncIdentifier;

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end