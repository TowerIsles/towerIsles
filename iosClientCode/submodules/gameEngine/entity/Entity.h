#import "Base.h"
#import "Identifier.h"

@class EntityConfig;
@class Component;
@class EntitySpec;

@interface EntityIdentifier : Identifier

+ (EntityIdentifier*)objectWithIntIdentfier:(int64_t)intIdentifier;

@end

@interface Entity : ManagedPropertiesObject
@property (nonatomic, retain, readonly) EntityIdentifier* entityIdentifier;
@property (nonatomic, retain, readonly) EntityConfig* entityConfig;
@property (nonatomic, assign) BOOL queuedForDestruction;

+ (Entity*)objectWithEntityIdentifier:(EntityIdentifier*)entityIdentifier
                         entityConfig:(EntityConfig*)entityConfig;

- (Component*)componentForClass:(Class)componentClass;

- (void)addComponent:(Component*)component;

- (NSArray*)entitySpecClasses;

- (EntitySpec*)entitySpecForClass:(Class)entitySpec;

- (void)addEntitySpec:(EntitySpec*)entitySpec;

- (void)injectIvarsIntoAllSpecs;

- (void)teardown;

@end
