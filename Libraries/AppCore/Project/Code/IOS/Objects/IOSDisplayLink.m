#import "DisplayLink.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface DisplayLink ()
@property (nonatomic, retain) CADisplayLink* displayLink;
@end

@implementation DisplayLink

+ (DisplayLink*)objectWithOwner:(id)owner
                 updateSelector:(SEL)updateSelector
                  frameInterval:(int)frameInterval
{
    DisplayLink* displayLink = [DisplayLink object];
    
    displayLink.displayLink = [[UIScreen mainScreen] displayLinkWithTarget:owner
                                                                  selector:updateSelector];
    
    [displayLink->_displayLink setFrameInterval:frameInterval]; // 1 - 60fps, 2 - 30fps, etc.
    
    [displayLink->_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                                    forMode:NSDefaultRunLoopMode];
    
    return displayLink;
}

- (void)invalidate
{
    [_displayLink invalidate];
}


@end
