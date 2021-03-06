#import "FrameTimeManager.h"
#import <QuartzCore/QuartzCore.h>

@interface FrameTimeManager ()
{
}
@property (nonatomic, assign) int frameCount;
@property (nonatomic, assign) NSTimeInterval frameStartTimeInSec;
@property (nonatomic, assign) NSTimeInterval frameTimeInSec;
@end


@implementation FrameTimeManager

- (id)init
{
    if (self = [super init])
    {
        _frameCount = -1;
        _frameTimeInSec = .016f;
        _frameStartTimeInSec = CACurrentMediaTime();
    }
    return self;
}

- (void)load
{
    [self registerPreUpdateBlock:^{
        ++self.frameCount;
        NSTimeInterval currentMediaTime = CACurrentMediaTime();
        self.frameTimeInSec = currentMediaTime - _frameStartTimeInSec;
        self.frameStartTimeInSec = currentMediaTime;
    }];
}

- (int)currentFrameNumber
{
    return _frameCount;
}

- (float)lastFrameTimeInSec
{
    return _frameTimeInSec;
}

- (float)currentFPS
{
    return 1.0f / _frameTimeInSec;
}

@end
