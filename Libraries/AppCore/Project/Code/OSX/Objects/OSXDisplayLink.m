#import "DisplayLink.h"

@interface DisplayLink ()
@property (nonatomic, retain) NSTimer* updateTimer;
@end

@implementation DisplayLink

+ (DisplayLink*)objectWithOwner:(id)owner
                 updateSelector:(SEL)updateSelector
                  frameInterval:(int)frameInterval
{
    DisplayLink* displayLink = [DisplayLink object];
    
    float timeIntervalInSeconds = frameInterval / 60.0f;
    
    displayLink.updateTimer = [NSTimer scheduledTimerWithTimeInterval:timeIntervalInSeconds
                                                               target:owner
                                                             selector:updateSelector
                                                             userInfo:nil
                                                              repeats:YES];

    return displayLink;
}

- (void)invalidate
{
    [_updateTimer invalidate];
}

@end
