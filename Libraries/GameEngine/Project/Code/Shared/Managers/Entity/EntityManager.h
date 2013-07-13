#import "Manager.h"

@class Identifier;
@class Entity;
@class EntityConfig;
@class EntityInstanceConfig;
@class EntitySpec;

@interface EntityManager : Manager

- (void)loadEntityConfigsFromFile:(NSString*)filename;

- (EntitySpec*)createEntitySpecFromEntityConfigId:(NSString*)entityConfigId;

- (EntitySpec*)createEntitySpecFromEntityInstanceConfig:(EntityInstanceConfig*)entityInstanceConfig;

- (void)queueEntityForRemoval:(Entity*)entityToRemove;

- (NSArray*)entitySpecInstancesConformingToSpec:(Class)entitySpecClass;

@end
