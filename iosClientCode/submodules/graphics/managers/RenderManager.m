#import "RenderManager.h"
#import "EAGLView.h"
#import <GLKit/GLKit.h>

// An array of 3 vectors which represents 3 vertices
static const GLfloat g_vertex_buffer_data[] = {
    -1.0f, -1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
    0.0f, 1.0f, -1.0f,
};

@interface RenderManager ()
{
	ViewManager* viewManager;
    
    GLuint vertexArrayID;
    GLuint vertexBuffer;
    
}
@property (nonatomic, retain) GLKBaseEffect* effect;

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

- (void)internal_setupOpenGL
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
}

- (void)setupLearning
{
    CheckGLError
    glGenVertexArraysOES(1, &vertexArrayID);
    glBindVertexArrayOES(vertexArrayID);
    CheckGLError
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data), g_vertex_buffer_data, GL_STATIC_DRAW);
    CheckGLError
}

- (void)load
{
    [self internal_setupOpenGL];
    
    [self setupLearning];
    
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
    
    
    glEnableClientState(GL_VERTEX_ARRAY);
    CheckGLError
    glEnableVertexAttribArray(0);
    CheckGLError
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    CheckGLError
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, (void*)0);
    CheckGLError
    glDrawArrays(GL_TRIANGLES, 0, 3);
    CheckGLError
    glDisableVertexAttribArray(0);
    CheckGLError
}

- (void)postUpdate
{
//    [EAGLContext setCurrentContext:_context];
//
//    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
//
    //glViewport(0, 0, _backingWidth, _backingHeight);
    
//    glClear(GL_COLOR_BUFFER_BIT);
//    
//    glClearColor(.9f, .3f, .4f, 1.f);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    CheckGLError
}

@end
