#import "RenderManager.h"
#import "EAGLView.h"

@interface RenderManager ()
{
	ViewManager* viewManager;
}

@property (nonatomic, retain) EAGLContext* context;
@property (nonatomic, assign) GLuint frameBuffer;
@property (nonatomic, assign) GLuint renderBuffer;
@property (nonatomic, assign) int backingWidth;
@property (nonatomic, assign) int backingHeight;

@end


@implementation RenderManager

- (void)dealloc
{
	[RenderManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (void)load
{
    ((CAEAGLLayer*)viewManager.getEAGLView.layer).drawableProperties = @{@(NO): kEAGLDrawablePropertyRetainedBacking,
                                                                         kEAGLColorFormatRGBA8: kEAGLDrawablePropertyColorFormat};
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_context];

    glGenFramebuffers(1, &_frameBuffer);
    glGenRenderbuffers(1, &_renderBuffer);
    
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
    
    [_context renderbufferStorage:GL_RENDERBUFFER
                     fromDrawable:(CAEAGLLayer*)viewManager.getEAGLView.layer];

    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_backingWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_backingHeight);
    
    CheckTrue(glCheckFramebufferStatus(GL_FRAMEBUFFER) == GL_FRAMEBUFFER_COMPLETE)
    
    glDisable(GL_DEPTH_TEST);
    
    
    [self.director registerPreUpdateBlock:^{
        [self preUpdate];
    }];

    [self.director registerUpdateBlock:^{
        [self update];
    }];
    
    [self.director registerPostUpdateBlock:^{
        [self postUpdate];
    }];
}

- (void)preUpdate
{
    
}

- (void)update
{
    
}

- (void)postUpdate
{
    //[EAGLContext setCurrentContext:_context];
    
    //glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    //glViewport(0, 0, _backingWidth, _backingHeight);
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glClearColor(.3f, .3f, .4f, 1.f);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    CheckGLError
}

@end
