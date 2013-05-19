#import "MenuManager.h"
#import "TestMainMenu.h"

@interface MenuManager ()
{
    ViewManager* viewManager;
}

@end


@implementation MenuManager

- (void)dealloc
{
	[MenuManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (void)showDebugMenu
{
    
}

- (void)showLoginMenu
{
    [viewManager showManagedViewOfClassOnDefaultLayer:TestMainMenu.class
                                           setupBlock:^(TestMainMenu* titleBarView) {

                                           }];
}

@end
