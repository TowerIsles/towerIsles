#import "RenderResource.h"

typedef enum
{
    ShaderAttributeVertex,
    ShaderAttributeNormal,
    ShaderAttributeCount
} ShaderAttribute;

@interface Shader : RenderResource
@property (nonatomic, assign) GLuint programHandle;
@property (nonatomic, retain) NSString* vertexShaderFilename;
@property (nonatomic, retain) NSString* fragmentShaderFilename;

- (void)create;

- (void)compileAndLink;

- (void)useProgram;

- (GLuint)getModelViewProjectionMatrixUniform;

- (GLuint)getNormalMatrixUniform;

- (GLuint)getAttributeLocation:(const char*)attributeName;

- (GLuint)getUniformLocation:(const char*)uniformName;

@end
