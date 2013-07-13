#import "ViewDirector.h"
#import "NSObject+Object.h"
#import "AppCoreAsserts.h"

@interface ViewDirector ()
{
    EAGLContext *glContext;
}
@property (nonatomic, assign) IBOutlet GLKView* glkView;
@property (nonatomic, copy) void(^drawCallbackBlock)(GLKView*, CGRect);
@end

@implementation ViewDirector

- (void)dealloc
{
    [ViewDirector releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)glkView:(GLKView*)view
     drawInRect:(CGRect)rect
{
    if (_drawCallbackBlock != nil)
    {
        _drawCallbackBlock(view, rect);
    }
}

- (void)setDrawCallback:(void(^)(GLKView*, CGRect))drawCallback
{
    CheckTrue(_drawCallbackBlock == nil);
    
    self.drawCallbackBlock = drawCallback;
}

- (void)addUIView:(UIView*)uiView
{
    [_glkView addSubview:uiView];
}

- (void)initOpenGLContext
{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    CheckNotNull(glContext);
    
    _glkView.context = glContext;
    _glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:glContext];
}

@end