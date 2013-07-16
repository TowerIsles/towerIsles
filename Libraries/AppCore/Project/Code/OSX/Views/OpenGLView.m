#import "OpenGLView.h"
#import "AppCoreAsserts.h"

@interface OpenGLView ()
@property (nonatomic, copy) void(^drawCallbackBlock)(OpenGLView*, CGRect);
@end

@implementation OpenGLView

- (void)registerDrawCallback:(void(^)(OpenGLView*, CGRect))drawCallback
{
    CheckTrue(_drawCallbackBlock == nil);
    
    self.drawCallbackBlock = drawCallback;
    
    float timeIntervalInSeconds = 1 / 60.0f;
    
    [NSTimer scheduledTimerWithTimeInterval:timeIntervalInSeconds
                                     target:self
                                   selector:@selector(draw)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)draw
{
    [self drawRect:self.frame];
}

- (void)drawRect:(NSRect)rect
{
    if (_drawCallbackBlock != nil)
    {
        _drawCallbackBlock(self, rect);
    }
}

@end
