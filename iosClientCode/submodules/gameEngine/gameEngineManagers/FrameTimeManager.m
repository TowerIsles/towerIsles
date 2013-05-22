#import "FrameTimeManager.h"
#import "FPSCounter.h"

@interface FrameTimeManager ()
{
    ViewManager* viewManager;
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
    [self.director registerPreUpdateBlock:^{
        ++self.frameCount;
        NSTimeInterval currentMediaTime = CACurrentMediaTime();
        self.frameTimeInSec = currentMediaTime - _frameStartTimeInSec;
        self.frameStartTimeInSec = currentMediaTime;
    }];

    [viewManager showManagedViewOfClassOnLayer:FPSCounter.class
                                     layerName:@"debug"
                                    setupBlock:^(FPSCounter* fpsCounter) {
                                        
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
