#import "Core.h"
#import "GraphicsBase.h"

@class Shader;

@interface RenderResourceManager : Manager

- (Shader*)shaderForIdentifier:(Identifier*)identifier;

- (void)loadShaders;

@end
