#import "Manager.h"
#import <UIKit/UIKit.h> // TODO - remove

@class TouchChannelConfig;
@class TouchChannel;

@interface TouchManager : Manager

- (TouchChannel*)createTouchChannelForView:(UIView*)targetView
                                withConfig:(TouchChannelConfig*)touchChannelConfig;

@end
