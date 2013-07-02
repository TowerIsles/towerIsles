#import "LoadingManager.h"
#import "GameUIManager.h"
#import "PlayerManager.h"
#import "TestSpec.h"
#import "SettingsManager.h"

@interface LoadingManager ()
{
	PlayerManager* playerManager;
    GameUIManager* gameUIManager;
    EntityManager* entityManager;
    SettingsManager* settingsManager;
}
@end

@implementation LoadingManager

- (void)load
{
#if DEBUG
    [gameUIManager showDebugMenu];
#endif
    
    if ([settingsManager.shouldLoginImplicitly getSettingValue])
    {
        [playerManager attemptImplicitLogin];
    }
    else
    {
        [gameUIManager showLoginMenu];
    }
}

- (void)reload
{
    performBlockAfterDelay(.5f, ^{
        [gameUIManager showLoginMenu];
    });
}

@end
