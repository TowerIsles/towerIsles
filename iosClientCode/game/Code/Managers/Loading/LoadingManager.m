#import "LoadingManager.h"
#import "MenuManager.h"
#import "PlayerManager.h"
#import "TestSpec.h"

@interface LoadingManager ()
{
	PlayerManager* playerManager;
    MenuManager* menuManager;
    EntityManager* entityManager;
}

@end


@implementation LoadingManager

- (void)dealloc
{
	[LoadingManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (void)load
{
#if DEBUG
    [menuManager showDebugMenu];
#endif
    
    if ([playerManager shouldLoginImplicitly])
    {
        [playerManager attemptImplicitLogin];
    }
    else
    {
        [menuManager showLoginMenu];
    }
}

- (void)update
{
    EntitySpec* entity = [entityManager createEntityFromEntityConfigId:@"entityConfig_1"];
    TestSpec* testSpec = entity.transformedToTestSpec;
    TestSpecTwo* testSpecTwo = testSpec.transformedToTestSpecTwo;
    testSpecTwo = testSpecTwo;
    //CheckTrue(testSpecTwo != nil);
}

@end
