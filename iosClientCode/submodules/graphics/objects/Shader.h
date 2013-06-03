#import "RenderResource.h"

@interface Shader : RenderResource
@property (nonatomic, assign) GLuint programHandle;

+ (Shader*)objectWithVertexShaderFilename:(NSString*)vertexShaderFilename
                   fragmentShaderFilename:(NSString*)fragmentShaderFilename;

- (void)useProgram;

- (GLuint)getModelViewProjectionMatrixUniform;

- (GLuint)getNormalMatrixUniform;

- (GLuint)getAttributeLocation:(const char*)attributeName;

- (GLuint)getUniformLocation:(const char*)uniformName;

@end
