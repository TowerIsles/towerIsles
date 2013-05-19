#import "Manager.h"

@class EntitySpec;

@interface EntityManager : Manager

- (EntitySpec*)createEntityFromEntityConfigId:(NSString*)entityConfigId;

- (void)queueEntityForRemoval:(EntitySpec*)entityToRemove;

- (NSArray*)specInstancesConformingToSpec:(Class)entitySpecClass;

@end
