#import "TestingManager.h"
#import "TestSpec.h"
#import "MathTesting.h"

@interface TestingManager ()
{
    EntityManager* entityManager;
    FrameTimeManager* frameTimeManager;
    ServerTimeManager* serverTimeManager;
}

@end


@implementation TestingManager

- (void)load
{
    NSLog(@"RUNNING TESTS");
    NSLog(@"=============");
    NSLog(@"=============");
    
    RunTestSuite(MathTesting);
    
    NSLog(@"=============");
    
//    performBlockAfterDelay(2, ^{
//        [self.director reload];
//    });
//    [self.director registerUpdateBlockAtFPS:30
//                                updateBlock:^{
//                                    [self update];//NSLog(@"30 HZ");
//                                }];
//
//    [self.director registerUpdateBlockAtFPS:5
//                                updateBlock:^{
//        NSLog(@"5 HZ");
//    }];
//    
//    [self.director registerUpdateBlockAtFPS:1
//                                updateBlock:^{
//                                    NSLog(@"1 HZ");
//                                }];
    
    performBlockAfterDelay(0, ^{
        [entityManager createEntitySpecFromEntityConfigId:@"entityConfig_box"];
    });

}

- (void)reload
{
//    performBlockAfterDelay(5, ^{
//        NSLog(@"function by...");
//    });
//    
//    performBlockAfterDelay(2, ^{
//        [self.director reload];
//    });
}

- (void)update
{
//    NSLog(@"%lld", serverTimeManager.getCurrentTimeInMs);
//    for (int i = 0; i < 1000; ++i)
//    {
//        EntitySpec* entity = [entityManager createEntitySpecFromEntityConfigId:@"entityConfig_1"];
//        TestSpec* testSpec = entity.transformedToTestSpec;
//        TestSpecTwo* testSpecTwo = testSpec.transformedToTestSpecTwo;
//        testSpecTwo = testSpecTwo;
//        [entity queueDestruction];
//    }
 //   [self.director reload];

}

@end
