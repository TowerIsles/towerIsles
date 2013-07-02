#import "GameUIManager.h"

#ifndef EDITOR
#import "FPSCounter.h"
#import "TestMainMenu.h"
#import "TouchManager.h"
#endif

@interface GameUIManager ()
{
#ifndef EDITOR
    TouchManager* touchManager;
    ViewManager* viewManager;
#endif
}

@end

#ifndef EDITOR

@implementation GameUIManager

- (void)load
{
    [viewManager showManagedViewOfClassOnLayer:FPSCounter.class
                                     layerName:@"debug"
                                    setupBlock:^(FPSCounter* fpsCounter) {
                                        
                                    }];
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

- (TouchChannel*)createTouchChannelOnGLViewWithConfig:(TouchChannelConfig*)touchChannelConfig
{
    [touchManager createTouchChannelForView:(UIView*)viewManager.getGLKView
                                 withConfig:touchChannelConfig];
}

@end

#else


@implementation GameUIManager
- (void)showDebugMenu {}
- (void)showLoginMenu {}

- (TouchChannel*)createTouchChannelOnGLViewWithConfig:(TouchChannelConfig*)touchChannelConfig
{
    return nil;
}

@end

#endif