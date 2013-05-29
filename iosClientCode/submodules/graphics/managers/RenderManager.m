#import "RenderManager.h"
#import "RenderResourceManager.h"
#import "Shader.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

GLfloat gVertexData[] =
{
    0.5f, 0.5f, 0.0f,    0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.0f,    0.0f, 0.0f, 1.0f,
    0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.0f,   0.0f, 0.0f, 1.0f
};

GLfloat gTexCoordData[] =
{
    1.0f, 1.0f,
    0.0f, 1.0f,
    1.0f, 0.0f,
    0.0f, 0.0f
};

@interface RenderManager ()
{
	ViewManager* viewManager;
    RenderResourceManager* renderResourceManager;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _texCoordBuffer;
    
    int uSamplerLoc;
    int aTexCoordLoc;
    
    // FBO variables
    GLuint fboHandle;
    GLuint depthBuffer;
    GLuint fboTex;
    int fbo_width;
    int fbo_height;
    
    // test
    GLuint texId;
    
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
    
    // FBO status check
    GLenum status;
    status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    switch(status) {
        case GL_FRAMEBUFFER_COMPLETE:
            NSLog(@"fbo complete");
            break;
            
        case GL_FRAMEBUFFER_UNSUPPORTED:
            NSLog(@"fbo unsupported");
            break;
            
        default:
            /* programming error; will fail on all hardware */
            NSLog(@"Framebuffer Error");
            break;
    }
    
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
    
    Shader* shader = [renderResourceManager shaderForIdentifier:[Identifier objectWithStringIdentifier:@"baseShader"]];
    
    glEnable(GL_DEPTH_TEST);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gVertexData), gVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    glGenBuffers(1, &_texCoordBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _texCoordBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gTexCoordData), gTexCoordData, GL_STATIC_DRAW);
    // get text coord attribute index
    
    aTexCoordLoc = [shader getAttributeLocation:"aTexCoord"];
    glEnableVertexAttribArray(aTexCoordLoc);
    glVertexAttribPointer(aTexCoordLoc, 2, GL_FLOAT, GL_FALSE, 0, BUFFER_OFFSET(0));
    // get sampler location
    uSamplerLoc = [shader getUniformLocation:"uSampler"];

    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = [shader getModelViewProjectionMatrixUniform];
    uniforms[UNIFORM_NORMAL_MATRIX] = [shader getNormalMatrixUniform];
    
    // initialize FBO
    [self setupFBO];
    
    // to test texturing
    GLubyte tex[] = {255, 0, 0, 255, 0, 255, 0, 255, 0, 255, 0, 255, 255, 0, 0, 255};
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &texId);
    glBindTexture(GL_TEXTURE_2D, texId);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE, tex);
    glBindTexture(GL_TEXTURE_2D, 0);
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
    [self renderFBO];
    
    // reset to main framebuffer
    [view bindDrawable];
    
    glViewport(0, 0, view.bounds.size.width, view.bounds.size.height);
    // render main
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //glEnable(GL_TEXTURE_2D);
    glActiveTexture(GL_TEXTURE0);
    
    // Render
    Shader* shader = [renderResourceManager shaderForIdentifier:[Identifier objectWithStringIdentifier:@"baseShader"]];
    [shader useProgram];

    glUniform1i(uSamplerLoc, 0);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    // bind to fbo texture
    glBindTexture(GL_TEXTURE_2D, fboTex);
    
    // uncomment line below and comment out[self renderFBO]; above to test with normal texture
    // glBindTexture(GL_TEXTURE_2D, texId);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    //glDisable(GL_TEXTURE_2D);
    
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
