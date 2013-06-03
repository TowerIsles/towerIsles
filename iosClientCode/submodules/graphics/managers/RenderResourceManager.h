#import "Core.h"
#import "GraphicsBase.h"

@class Shader;
@class Mesh;

@interface RenderResourceManager : Manager

- (Shader*)shaderForIdentifier:(Identifier*)identifier;

- (Mesh*)meshForIdentifier:(Identifier*)identifier;

- (void)loadShaders;

- (void)loadModels;

@end
