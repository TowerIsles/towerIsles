#import "SceneNode.h"
#import "Asserts.h"
#import "Renderable.h"

@implementation SceneNodeConfig
@end

@interface SceneNode ()
{
	
}
@property (nonatomic, retain) NSMutableArray* renderables;

@end


@implementation SceneNode

- (id)init
{
    if (self = [super init])
    {
        _renderables = [NSMutableArray new];
    }
    return self;
}

+ (SceneNode*)createRootNode
{
    SceneNode* rootNode = [SceneNode object];
    
    SceneNodeConfig* sceneNodeConfig = [SceneNodeConfig object];
    sceneNodeConfig.position = Vec3_Zero;
    sceneNodeConfig.scale = Vec3_UnitScale;
    sceneNodeConfig.orientation = Quat_Identity;
    
    [rootNode configureWithIdentifier:[Identifier objectWithStringIdentifier:@"root"]
                           nodeConfig:sceneNodeConfig];
    
    return rootNode;
}

- (SceneNode*)createAndAddCameraNodeWithIdentifier:(Identifier*)nodeIdentifier;
{
    CheckNotNull(nodeIdentifier);
    
    SceneNode* cameraNode = [SceneNode object];
    
    SceneNodeConfig* sceneNodeConfig = [SceneNodeConfig object];
    sceneNodeConfig.position = Vec3Make(0, 0, -1);
    sceneNodeConfig.scale = Vec3_UnitScale;
    sceneNodeConfig.orientation = Quat_Identity;
    
    [cameraNode configureWithIdentifier:nodeIdentifier
                             nodeConfig:sceneNodeConfig];
    
    [self addChildNode:cameraNode];

    return cameraNode;
}

- (SceneNode*)createAndAddNodeWithIdentifier:(Identifier*)nodeIdentifier
                             sceneNodeConfig:(SceneNodeConfig*)sceneNodeConfig
{
    CheckNotNull(sceneNodeConfig);
    CheckNotNull(nodeIdentifier);
    
    SceneNode* childNode = [SceneNode object];

    [childNode configureWithIdentifier:nodeIdentifier
                            nodeConfig:sceneNodeConfig];
    
    [self addChildNode:childNode];
    
    return childNode;
}

- (void)renderWithCamera:(Camera*)camera
{
    BOOL visibleInScene = YES;
    
    if (visibleInScene)
    {
        for (Renderable* renderable in _renderables)
        {
            [renderable renderWithCamera:camera];
        }
    }
}

- (void)addRenderable:(Renderable*)renderable
{
    CheckTrue(![_renderables containsObject:renderable]);
    
    renderable.node = self;
    
    [_renderables addObject:renderable];
}

@end
