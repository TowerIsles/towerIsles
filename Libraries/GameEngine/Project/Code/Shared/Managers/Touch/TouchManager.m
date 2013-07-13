#import "TouchManager.h"
#import "TouchChannel.h"

@interface TouchManager ()
{
}
@property (nonatomic, retain) NSMutableArray* touchChannels;
@end


@implementation TouchManager

- (id)init
{
    if (self = [super init])
    {
        _touchChannels = [NSMutableArray new];
    }
    return self;
}

- (void)load
{
    [self registerPostUpdateBlock:^{
        [self internal_refreshTouchChannels];
    }];
}

- (TouchChannel*)createTouchChannelForView:(UIView*)targetView
                                withConfig:(TouchChannelConfig*)touchChannelConfig;
{
    TouchChannel* touchChannel = [TouchChannel object];
    
    [touchChannel observeTouchesOnView:targetView
                            withConfig:touchChannelConfig];
    
    [_touchChannels addObject:touchChannel];
    
    return touchChannel;
}

- (void)internal_refreshTouchChannels
{
    for (TouchChannel* touchChannel in _touchChannels)
    {
        [touchChannel refresh];
    }
}

@end
