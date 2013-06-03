#import "RenderManager.h"
#import "RenderResourceManager.h"
#import "Shader.h"
#import "Mesh.h"
#import "PrimitiveData.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

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
    
    GLKMatrix4 _modelViewProjectionMatrix; // into model location. apply transform or w/e
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    // FBO variables
    GLuint fboHandle;
    GLuint depthBuffer;
    GLuint fboTex;
    int fbo_width;
    int fbo_height;
    
    // GL context
    EAGLContext *glContext;
    
    GLint defaultFBO;
}

@end


@implementation RenderManager

- (void)displayMatrix4:(GLKMatrix4)matrix
{
    NSLog(@"displayMatrix4");
    NSLog(@"%f, %f, %f, %f", matrix.m00, matrix.m01, matrix.m02, matrix.m03);
    NSLog(@"%f, %f, %f, %f", matrix.m10, matrix.m11, matrix.m12, matrix.m13);
    NSLog(@"%f, %f, %f, %f", matrix.m20, matrix.m21, matrix.m22, matrix.m23);
    NSLog(@"%f, %f, %f, %f", matrix.m30, matrix.m31, matrix.m32, matrix.m33);
}

- (void)displayMatrix3:(GLKMatrix3)matrix
{
    NSLog(@"displayMatrix3");
    NSLog(@"%f, %f, %f", matrix.m00, matrix.m01, matrix.m02);
    NSLog(@"%f, %f, %f", matrix.m10, matrix.m11, matrix.m12);
    NSLog(@"%f, %f, %f", matrix.m20, matrix.m21, matrix.m22);
}

- (void)dealloc
{
	[RenderManager releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (void)setupFBO
{
    fbo_width = 512;
    fbo_height = 512;
    
    glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFBO);
    
    glGenFramebuffers(1, &fboHandle);
    glGenTextures(1, &fboTex);
    glGenRenderbuffers(1, &depthBuffer);
    
    glBindFramebuffer(GL_FRAMEBUFFER, fboHandle);
    
    glBindTexture(GL_TEXTURE_2D, fboTex);
    glTexImage2D( GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 fbo_width, fbo_height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 NULL);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, fboTex, 0);
    
    glBindRenderbuffer(GL_RENDERBUFFER, depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24_OES, fbo_width, fbo_height);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuffer);
    
    CheckGLError
    
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFBO);
}

- (void)internal_setupOpenGL
{
    glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!glContext) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView* view = viewManager.getGLKView;
    view.context = glContext;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    [EAGLContext setCurrentContext:glContext];
    
    [renderResourceManager loadShaders];
    [renderResourceManager loadMaterials];
    [renderResourceManager loadModels];
    
    Shader* shader = [renderResourceManager shaderForIdentifier:[Identifier objectWithStringIdentifier:@"baseShader"]];
    
    glEnable(GL_DEPTH_TEST);

    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = [shader getModelViewProjectionMatrixUniform];
    uniforms[UNIFORM_NORMAL_MATRIX] = [shader getNormalMatrixUniform];
    
    // initialize FBO
    [self setupFBO];
}

// render FBO
- (void)renderFBO
{
    glBindTexture(GL_TEXTURE_2D, 0);
    //glEnable(GL_TEXTURE_2D);
    glBindFramebuffer(GL_FRAMEBUFFER, fboHandle);
    
    glViewport(0,0, fbo_width, fbo_height);
    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFBO);
}

- (void)glkView:(GLKView*)view
     drawInRect:(CGRect)rect
{
    // render FBO tex
//    [self renderFBO];
    
//    reset to main framebuffer
    [view bindDrawable];
    
    glViewport(0, 0, view.bounds.size.width, view.bounds.size.height);
    // render main
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    {
        Mesh* mesh = [renderResourceManager meshForIdentifier:[Identifier objectWithStringIdentifier:@"test"]];
        [mesh prepareForRender];

        CheckGLError
        
        glActiveTexture(GL_TEXTURE0);
        
        // Render Objects
        Shader* shader = [renderResourceManager shaderForIdentifier:[Identifier objectWithStringIdentifier:@"baseShader"]];
        [shader useProgram];
        
        glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
        glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
        
        Material* material = [renderResourceManager materialForIdentifier:[Identifier objectWithStringIdentifier:@"colorPurple"]];
        [material prepareForRender];
        
        CheckGLError
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
    }
    {
        
        Mesh* mesh = [renderResourceManager meshForIdentifier:[Identifier objectWithStringIdentifier:@"test2"]];
        [mesh prepareForRender];

        CheckGLError
        
        glActiveTexture(GL_TEXTURE0);
        
        // Render Objects
        Shader* shader = [renderResourceManager shaderForIdentifier:[Identifier objectWithStringIdentifier:@"baseShader"]];
        [shader useProgram];
        
        glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
        glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
        
        Material* material = [renderResourceManager materialForIdentifier:[Identifier objectWithStringIdentifier:@"colorYellow"]];
        [material prepareForRender];
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
    }
    
    CheckGLError
}

- (void)load
{
    [self internal_setupOpenGL];
    
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
    float aspect = fabsf(320.0f / 480.0f);
    
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
//    [self displayMatrix4:projectionMatrix];
    // Compute the model view matrix for the object rendered with ES2
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -10.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _rotation, 1.0f, 1.0f, 1.0f);
    
    _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    //[self displayMatrix3:_normalMatrix];
    
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    //[self displayMatrix4:_modelViewProjectionMatrix];
    
    _rotation += .14;//16f * 0.5f;
}

- (void)postUpdate
{
}

@end
