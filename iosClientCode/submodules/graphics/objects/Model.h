#import "Renderable.h"

@class Mesh;
@class Shader;
@class Material;

@interface Model : Renderable

- (void)addMesh:(Mesh*)mesh;

- (void)addShader:(Shader*)shader;

- (void)addMaterial:(Material*)material;

@end
