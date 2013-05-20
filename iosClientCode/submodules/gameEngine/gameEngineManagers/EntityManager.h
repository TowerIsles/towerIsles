#import "Manager.h"

@class EntitySpec;
@class Entity;

@interface EntityManager : Manager

- (EntitySpec*)createEntitySpecFromEntityConfigId:(NSString*)entityConfigId;

- (void)queueEntityForRemoval:(Entity*)entityToRemove;

- (void)queueAllEntitiesForRemoval;

- (NSArray*)entitySpecInstancesConformingToSpec:(Class)entitySpecClass;

@end
