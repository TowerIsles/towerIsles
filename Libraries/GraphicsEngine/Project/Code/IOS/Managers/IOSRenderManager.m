#import "RenderManager.h"
#import "RenderResourceManager.h"
#import "Shader.h"
#import "Mesh.h"
#import "PrimitiveData.h"
#import "GraphicsBase.h"
#import "SceneManager.h"

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

@interface RenderManager ()
{
	ViewManager* viewManager;
    RenderResourceManager* renderResourceManager;
    SceneManager* sceneManager;
    
//    // FBO variables
//    GLuint fboHandle;
//    GLuint depthBuffer;
//    GLuint fboTex;
//    int fbo_width;
//    int fbo_height;
    
    // GL context
    
    GLint defaultFBO;
    
    BOOL isDrawing;
}

@end


@implementation RenderManager

- (void)dealloc
{
	[RenderManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}
//
//- (void)setupFBO
//{
//    fbo_width = 512;
//    fbo_height = 512;
//    
//    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFBO);
//    
//    glGenFramebuffers(1, &fboHandle);
//    glGenTextures(1, &fboTex);
//    glGenRenderbuffers(1, &depthBuffer);
//    
//    glBindFramebuffer(GL_FRAMEBUFFER, fboHandle);
//    
//    glBindTexture(GL_TEXTURE_2D, fboTex);
//    glTexImage2D( GL_TEXTURE_2D,
//                 0,
//                 GL_RGBA,
//                 fbo_width, fbo_height,
//                 0,
//                 GL_RGBA,
//                 GL_UNSIGNED_BYTE,
//                 NULL);
//    
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//    
//    
//    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, fboTex, 0);
//    
//    glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
//    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24_OES, fbo_width, fbo_height);
//    
//    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer);
//    
//    CheckGLError
//    
//    glBindFramebuffer(GL_FRAMEBUFFER, defaultFBO);
//}

- (void)internal_setupOpenGL
{
    [viewManager initOpenGLContext];
    
    [renderResourceManager loadShaders];
    [renderResourceManager loadMaterials];
    [renderResourceManager loadModels];
    
    glEnable(GL_DEPTH_TEST);
    
    //[self setupFBO];
}

// render FBO
//- (void)renderFBO
//{
//    glBindTexture(GL_TEXTURE_2D, 0);
//    //glEnable(GL_TEXTURE_2D);
//    glBindFramebuffer(GL_FRAMEBUFFER, fboHandle);
//    
//    glViewport(0,0, fbo_width, fbo_height);
//    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
//    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
//    
//    glBindFramebuffer(GL_FRAMEBUFFER, defaultFBO);
//}

- (void)internal_clear
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    CheckGLError
}

- (void)glkView:(GLKView*)view
     drawInRect:(CGRect)rect
{
    // TODO : set once, update on view change - see drawInRect
    glViewport(0, 0, 320.0f, 480.0f);
    
    [self internal_clear];
    
    [sceneManager renderActiveScene];
}

- (void)openGLView:(OpenGLView*)view
        drawInRect:(CGRect)rect
{
    
}

- (void)load
{
    [self internal_setupOpenGL];
}

@end
