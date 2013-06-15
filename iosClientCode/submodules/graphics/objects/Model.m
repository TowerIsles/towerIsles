#import "Model.h"
#import "Shader.h"
#import "Mesh.h"
#import "Material.h"
#import "Camera.h"
#import "GraphicsBase.h"
#import "Node.h"
#import <GLKit/GLKit.h>
#import "MathValidation.h"

@interface Model ()
{
	
}
@property (nonatomic, retain) Shader* shader;
@property (nonatomic, retain) Mesh* mesh;
@property (nonatomic, retain) Material* material;
@end


@implementation Model

- (void)renderWithCamera:(Camera*)camera
{
    // TODO: calculate on camera. pass in camera. some gl matrix stack?
    float aspect = fabsf(320.0f / 480.0f); // TODO : derive this from viewport
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    [_mesh prepareForRender];
    
    [_shader useProgram];
    
    [_material prepareForRender];
    
    GLKMatrix4 modelMatrix = *Node_getTransform(self.node);
    
    GLKMatrix4* viewMatrix = [camera getViewMatrix];
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(*viewMatrix, modelMatrix);
    
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);
    
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    ValidateMat4(modelMatrix);
    
    ValidateMat4((*viewMatrix));

    ValidateMat4(modelViewMatrix);
    
    ValidateMat3(normalMatrix);
    
    ValidateMat4(modelViewProjectionMatrix);
    
    [_shader sendModelViewProjectionMatrix:&modelViewProjectionMatrix];
    
    [_shader sendNormalMatrix:&normalMatrix];
    
    [_mesh drawBuffers];
}

- (void)addMesh:(Mesh*)mesh
{
    CheckTrue(_mesh == nil);
    
    self.mesh = mesh;
}

- (void)addShader:(Shader*)shader
{
    CheckTrue(_shader == nil);
    
    self.shader = shader;
}

- (void)addMaterial:(Material*)material
{
    CheckTrue(_material == nil);
    
    self.material = material;
}

@end
