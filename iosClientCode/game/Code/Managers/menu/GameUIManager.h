#import "Game.h"

@class TouchChannel;
@class TouchChannelConfig;

@interface GameUIManager : Manager

- (void)showDebugMenu;

- (void)showLoginMenu;

- (TouchChannel*)createTouchChannelOnGLViewWithConfig:(TouchChannelConfig*)touchChannelConfig;

@end
