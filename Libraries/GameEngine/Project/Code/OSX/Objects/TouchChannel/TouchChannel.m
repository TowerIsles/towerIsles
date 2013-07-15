#import "TouchChannel.h"

@interface TouchChannelConfig ()
{
}
@end

@implementation TouchChannelConfig
@end



@interface TouchChannel ()
{
}
@property (nonatomic, retain) TouchChannelConfig* config;
@property (nonatomic, retain) NSViewController* viewToObserve;
@end


@implementation TouchChannel

- (void)refresh
{
}

- (void)observeTouchesOnView:(id)viewToObserve
                  withConfig:(TouchChannelConfig*)config;
{
    CheckIsKindOfClass(viewToObserve, NSViewController.class);

    self.config = config;
    
    self.viewToObserve = viewToObserve;
}

@end
