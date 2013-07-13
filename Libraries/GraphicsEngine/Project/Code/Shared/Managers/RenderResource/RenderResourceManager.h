#import "Manager.h"
#import "GraphicsBase.h"

@class Shader;
@class Mesh;
@class Material;

@interface RenderResourceManager : Manager

- (Shader*)shaderForIdentifier:(Identifier*)identifier;

- (Mesh*)meshForIdentifier:(Identifier*)identifier;

- (Material*)materialForIdentifier:(Identifier*)identifier;

- (void)loadShaders;

- (void)loadModels;

- (void)loadMaterials;

@end
