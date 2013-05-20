#import "TestingManager.h"
#import "TestSpec.h"

@interface TestingManager ()
{
    EntityManager* entityManager;
}

@end


@implementation TestingManager

- (void)load
{
    
}

- (void)unload
{
    
}

- (void)update
{
//    for (int i = 0; i < 1000; ++i)
//    {
//        EntitySpec* entity = [entityManager createEntitySpecFromEntityConfigId:@"entityConfig_1"];
//        TestSpec* testSpec = entity.transformedToTestSpec;
//        TestSpecTwo* testSpecTwo = testSpec.transformedToTestSpecTwo;
//        testSpecTwo = testSpecTwo;
//        //[entity queueDestruction];
//    }
//    
//    [entityManager queueAllEntitiesForRemoval];

    [self.director reload];
}

@end
