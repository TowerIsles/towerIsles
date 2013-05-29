#import "RenderResourceManager.h"
#import "Shader.h"

@interface RenderResourceManager ()
{
	
}
@property (nonatomic, retain) NSMutableDictionary* shadersByIdentifier;
@end


@implementation RenderResourceManager

- (id)init
{
    if (self = [super init])
    {
        _shadersByIdentifier = [NSMutableDictionary new];
    }
    return self;
}

- (Shader*)shaderForIdentifier:(Identifier*)identifier
{
    CheckNotNull([_shadersByIdentifier objectForKey:identifier]);
    
    return [_shadersByIdentifier objectForKey:identifier];
}

- (void)loadShaders
{
    [self createShaderWithIdentifier:[Identifier objectWithStringIdentifier:@"baseShader"]
                vertexShaderFilename:[ResourceManager formatPathForResourceWithName:@"Shaders/vertexShader.vsh"]
              fragmentShaderFilename:[ResourceManager formatPathForResourceWithName:@"Shaders/fragmentShader.fsh"]];
}

- (Shader*)createShaderWithIdentifier:(Identifier*)identifier
                 vertexShaderFilename:(NSString*)vertexShaderFilename
               fragmentShaderFilename:(NSString*)fragmentShaderFilename
{
    Shader* shader = [Shader object];
    shader.vertexShaderFilename = vertexShaderFilename;
    shader.fragmentShaderFilename = fragmentShaderFilename;
    
    [shader create];
    
    [shader compileAndLink];
    
    [_shadersByIdentifier setObject:shader
                             forKey:identifier];
    
    return shader;
}

@end
