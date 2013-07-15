#import "Manager.h"

@class TouchChannelConfig;
@class TouchChannel;

@interface TouchManager : Manager

- (TouchChannel*)createTouchChannelForView:(id)targetView
                                withConfig:(TouchChannelConfig*)touchChannelConfig;

@end
