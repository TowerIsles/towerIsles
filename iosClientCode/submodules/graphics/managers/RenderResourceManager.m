#import "RenderResourceManager.h"
#import "Shader.h"
#import "Mesh.h"
#import "PrimitiveData.h"

@interface RenderResourceManager ()
{
	
}
@property (nonatomic, retain) NSMutableDictionary* shadersByIdentifier;
@property (nonatomic, retain) NSMutableDictionary* meshesByIdentifier;
@end


@implementation RenderResourceManager

- (id)init
{
    if (self = [super init])
    {
        _shadersByIdentifier = [NSMutableDictionary new];
        _meshesByIdentifier = [NSMutableDictionary new];
    }
    return self;
}

- (Shader*)shaderForIdentifier:(Identifier*)identifier
{
    CheckNotNull([_shadersByIdentifier objectForKey:identifier]);
    
    return [_shadersByIdentifier objectForKey:identifier];
}

- (Mesh*)meshForIdentifier:(Identifier*)identifier
{
    CheckNotNull([_meshesByIdentifier objectForKey:identifier]);
    
    return [_meshesByIdentifier objectForKey:identifier];
}

- (void)loadShaders
{
    [self internal_createShaderWithIdentifier:[Identifier objectWithStringIdentifier:@"baseShader"]
                         vertexShaderFilename:[ResourceManager formatPathForResourceWithName:@"Shaders/vertexShader.vsh"]
                       fragmentShaderFilename:[ResourceManager formatPathForResourceWithName:@"Shaders/fragmentShader.fsh"]];
}

- (Shader*)internal_createShaderWithIdentifier:(Identifier*)identifier
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

- (void)loadModels
{
    Mesh* mesh = [Mesh object];
    mesh.type = MeshTypeMovablePrimitive;
    [mesh createFromData:gVertexData
                dataSize:sizeof(GL_FLOAT) * 32];
    [_meshesByIdentifier setObject:mesh
                            forKey:[Identifier objectWithStringIdentifier:@"test"]];
    
    Mesh* mesh2 = [Mesh object];
    mesh2.type = MeshTypeMovablePrimitive;
    [mesh2 createFromData:gVertexData2
                dataSize:sizeof(GL_FLOAT) * 32];
    [_meshesByIdentifier setObject:mesh2
                            forKey:[Identifier objectWithStringIdentifier:@"test2"]];
}

@end
