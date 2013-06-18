#import "Base.h"
#import "Identifier.h"

@class EntityConfig;
@class Component;
@class EntitySpec;

@interface Entity : ManagedPropertiesObject
@property (nonatomic, retain, readonly) Identifier* entityIdentifier;
@property (nonatomic, retain, readonly) EntityConfig* entityConfig;
@property (nonatomic, assign) BOOL queuedForDestruction;

+ (Entity*)objectWithIdentifier:(Identifier*)entityIdentifier
                   entityConfig:(EntityConfig*)entityConfig;

- (Component*)componentForClass:(Class)componentClass;

- (void)addComponent:(Component*)component;

- (NSArray*)entitySpecClasses;

- (EntitySpec*)entitySpecForClass:(Class)entitySpec;

- (void)addEntitySpec:(EntitySpec*)entitySpec;

- (void)injectIvarsIntoAllSpecs;

- (void)loadAllSpecs;

- (void)teardown;

- (NSDictionary*)serializedRepresentationForConfigFile;

- (NSDictionary*)serializedRepresentationForOfflineDatabase;

@end
