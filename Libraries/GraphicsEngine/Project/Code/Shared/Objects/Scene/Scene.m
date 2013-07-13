#import "Scene.h"
#import "SceneNode.h"
#import "AppCoreAsserts.h"
#import "Camera.h"

@implementation SceneConfig
@end

@interface Scene ()
{
	
}
@property (nonatomic, retain) Identifier* identifier;
@property (nonatomic, retain) SceneNode* rootNode;
@property (nonatomic, retain) SceneNode* cameraOneNode;
@property (nonatomic, retain) NSMutableDictionary* sceneNodesByIdentifier;
@property (nonatomic, retain) Camera* activeCamera;

// ambient light
// fog
// skyDome/Box/Plane
// activeViewport
// camera
// renderQueue?
 
@end


@implementation Scene

+ (Scene*)objectWithIdentifier:(Identifier*)sceneIdentifier
                   sceneConfig:(SceneConfig*)sceneConfig
{
    Scene* scene = [Scene object];
    
    scene.sceneNodesByIdentifier = [NSMutableDictionary object];
    
    scene.rootNode = [SceneNode createRootNode];
    
    scene.cameraOneNode = [scene->_rootNode createAndAddCameraNodeWithIdentifier:[Identifier objectWithStringIdentifier:@"camera1"]];
    
    scene.identifier = [Identifier objectWithStringIdentifier:sceneIdentifier.stringValue];
    
    scene.activeCamera = [Camera object];
    
    scene.activeCamera.node = scene->_cameraOneNode;
    
    return scene;
}

- (SceneNode*)rootSceneNode
{
    return _rootNode;
}

- (SceneNode*)cameraOneNode
{
    return _cameraOneNode;
}

- (Camera*)getActiveCamera
{
    return _activeCamera;
}

- (SceneNode*)createAndAddSceneNodeWithIdentifer:(Identifier*)nodeIdentifier
                                 sceneNodeConfig:(SceneNodeConfig*)sceneNodeConfig
                            parentNodeIdentifier:(Identifier*)parentNodeIdentifier
{
    SceneNode* node = [self internal_findNodeWithIdentifier:parentNodeIdentifier];
    
    CheckTrue([self internal_findNodeWithIdentifier:nodeIdentifier] == nil);
    
    return [node createAndAddNodeWithIdentifier:nodeIdentifier
                                sceneNodeConfig:sceneNodeConfig];
}

- (SceneNode*)internal_findNodeWithIdentifier:(Identifier*)nodeIdentifier
{
    if (nodeIdentifier == nil)
        return _rootNode;
    
    return [_sceneNodesByIdentifier objectForKey:nodeIdentifier];
}

- (void)renderVisibleNodes
{
    [_rootNode bakeTransformAndRenderWithCamera:_activeCamera];
}

@end
