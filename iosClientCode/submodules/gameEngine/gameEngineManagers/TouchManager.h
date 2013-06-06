#import "Core.h"

@class TouchChannelConfig;
@class TouchChannel;

@interface TouchManager : Manager

- (TouchChannel*)createTouchChannelForView:(UIView*)targetView
                                withConfig:(TouchChannelConfig*)touchChannelConfig;

@end
