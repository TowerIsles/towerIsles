#import "Model.h"
#import "Shader.h"
#import "Mesh.h"
#import "Material.h"

@interface Model ()
{
	
}
@property (nonatomic, retain) Shader* shader;
@property (nonatomic, retain) Mesh* mesh;
@property (nonatomic, retain) Material* material;
@end


@implementation Model

- (void)render
{
    [_mesh prepareForRender];
    
    [_shader useProgram];
    
    // set matricies.
    
    // bind textures
    
    // glDrawArrays
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, [_mesh vertexCount]);
}

@end
