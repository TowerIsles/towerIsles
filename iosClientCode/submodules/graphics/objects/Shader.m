#import "Shader.h"
#import "Asserts.h"
#import "GraphicsBase.h"

@interface Shader ()
{	
}
@property (nonatomic, retain) NSString* vertexShaderFilename;
@property (nonatomic, retain) NSString* fragmentShaderFilename;
@end


@implementation Shader

- (GLuint)getModelViewProjectionMatrixUniform
{
    return glGetUniformLocation(_programHandle, "modelViewProjectionMatrix");
}

- (GLuint)getNormalMatrixUniform
{
    return glGetUniformLocation(_programHandle, "normalMatrix");
}

- (GLuint)getAttributeLocation:(const char*)attributeName
{
    return glGetAttribLocation(_programHandle, attributeName);
}

- (GLuint)getUniformLocation:(const char*)uniformName
{
    return glGetUniformLocation(_programHandle, uniformName);
}

+ (Shader*)objectWithVertexShaderFilename:(NSString*)vertexShaderFilename
                   fragmentShaderFilename:(NSString*)fragmentShaderFilename
{
    Shader* shader = [Shader object];
    shader.vertexShaderFilename = vertexShaderFilename;
    shader.fragmentShaderFilename = fragmentShaderFilename;
    
    [shader internal_create];
    
    [shader internal_compileAndLink];
    
    return shader;
}

- (void)internal_create
{
    self.programHandle = glCreateProgram();
    
    CheckGLError
}

- (void)internal_compileAndLink
{
    GLuint vertexShader = [self internal_compileShaderWithFilename:_vertexShaderFilename
                                                              type:GL_VERTEX_SHADER];
    
    GLuint fragmentShader = [self internal_compileShaderWithFilename:_fragmentShaderFilename
                                                                type:GL_FRAGMENT_SHADER];
    
    [self internal_bindAttributes];
    
    [self internal_link];
    
    [self internal_detachShader:fragmentShader];
    
    [self internal_detachShader:vertexShader];
}

- (void)useProgram
{
    CheckGLError
    
    glUseProgram(_programHandle);
    
    CheckGLError
}

- (void)internal_printDebugLogForHandle:(GLuint)handle
{
    return;
#if DEBUG
    GLint logLength;
    
    glGetShaderiv(handle, GL_INFO_LOG_LENGTH, &logLength);
    
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        
        glGetShaderInfoLog(handle, logLength, &logLength, log);
        
        NSLog(@"Shader compile log:\n%s", log);
        
        free(log);
    }
    
    CheckGLError
#endif
}

- (GLuint)internal_compileShaderWithFilename:(NSString*)filename
                                        type:(GLuint)type
{
    GLuint shaderHandle;
    
    GLint status;
    
    const GLchar *source = (GLchar *)[[NSString stringWithContentsOfFile:filename
                                                                encoding:NSUTF8StringEncoding
                                                                   error:nil] UTF8String];
    
    CheckNotNull(source);
    
    shaderHandle = glCreateShader(type);
    
    glShaderSource(shaderHandle, 1, &source, NULL);
    
    glCompileShader(shaderHandle);
    
    [self internal_printDebugLogForHandle:shaderHandle];
    
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &status);
    
    CheckTrue(status != 0);
    
    glAttachShader(_programHandle, shaderHandle);
    
    CheckGLError
    
    return shaderHandle;
}

- (void)internal_bindAttributes
{
    glBindAttribLocation(_programHandle, GLKVertexAttribPosition, "position");
    
    CheckGLError
    
    glBindAttribLocation(_programHandle, GLKVertexAttribNormal, "normal");
    
    CheckGLError
    
    glBindAttribLocation(_programHandle, GLKVertexAttribTexCoord0, "aTexCoord");
}

- (void)internal_link
{
    GLint status;
    
    glLinkProgram(_programHandle);
    
    CheckGLError
    
    [self internal_printDebugLogForHandle:_programHandle];
    
    glGetProgramiv(_programHandle, GL_LINK_STATUS, &status);
    
    CheckTrue(status != 0);
    
    CheckGLError
}

- (void)internal_detachShader:(GLuint)shader
{
    glDetachShader(_programHandle, shader);
    
    CheckGLError
    
    glDeleteShader(shader);
    
    CheckGLError
}

@end
