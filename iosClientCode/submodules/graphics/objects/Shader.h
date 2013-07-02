#import "RenderResource.h"
#import "GraphicsBase.h"

@interface Shader : RenderResource
@property (nonatomic, assign) GLuint programHandle;

+ (Shader*)objectWithVertexShaderFilename:(NSString*)vertexShaderFilename
                   fragmentShaderFilename:(NSString*)fragmentShaderFilename;

- (void)useProgram;

- (GLuint)getModelViewProjectionMatrixUniform;

- (GLuint)getNormalMatrixUniform;

- (void)sendModelViewProjectionMatrix:(GLKMatrix4*)modelViewProjectionMatrix;

- (void)sendNormalMatrix:(GLKMatrix3*)normalMatrix;

@end
