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

@end
