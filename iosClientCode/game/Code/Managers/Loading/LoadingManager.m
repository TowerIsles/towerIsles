#import "LoadingManager.h"
#import "MenuManager.h"
#import "PlayerManager.h"
#import "TestSpec.h"
#import "SettingsManager.h"

@interface LoadingManager ()
{
	PlayerManager* playerManager;
    MenuManager* menuManager;
    EntityManager* entityManager;
    SettingsManager* settingsManager;
}
@end

@implementation LoadingManager

- (void)load
{
#if DEBUG
    [menuManager showDebugMenu];
#endif
    
    if ([settingsManager.shouldLoginImplicitly getSettingValue])
    {
        [playerManager attemptImplicitLogin];
    }
    else
    {
        [menuManager showLoginMenu];
    }
}

- (void)reload
{
    performBlockAfterDelay(.5f, ^{
        [menuManager showLoginMenu];
    });
}

@end
