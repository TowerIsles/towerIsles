#import "Scene.h"
#import "SceneNode.h"
#import "Asserts.h"

@implementation SceneConfig
@end

@interface Scene ()
{
	
}
@property (nonatomic, retain) Identifier* identifier;
@property (nonatomic, retain) SceneNode* root;
@property (nonatomic, retain) NSMutableDictionary* sceneNodesByIdentifier;
// ambient light
// fog
// skyDome/Box/Plane
// activeViewport
// camera
// renderQueue? 
@end


@implementation Scene

- (void)configureWithIdentifier:(Identifier*)sceneIdentifier
                    sceneConfig:(SceneConfig*)sceneConfig
{
    self.sceneNodesByIdentifier = [NSMutableDictionary object];
    
    self.root = [SceneNode object];
    
    self.identifier = [Identifier objectWithStringIdentifier:sceneIdentifier.stringValue];
}

- (SceneNode*)rootSceneNode
{
    return _root;
}

- (SceneNode*)createAndAddSceneNodeWithIdentifer:(Identifier*)nodeIdentifier
                                 sceneNodeConfig:(SceneNodeConfig*)sceneNodeConfig
                            parentNodeIdentifier:(Identifier*)parentNodeIdentifier
{
    SceneNode* node = [self internal_findNodeWithIdentifier:parentNodeIdentifier];
    
    return [node createAndAddNodeWithIdentifier:nodeIdentifier
                                sceneNodeConfig:sceneNodeConfig];
}

- (SceneNode*)internal_findNodeWithIdentifier:(Identifier*)nodeIdentifier
{
    if (nodeIdentifier == nil)
        return _root;
    
    CheckNotNull([_sceneNodesByIdentifier objectForKey:nodeIdentifier]);
    
    return [_sceneNodesByIdentifier objectForKey:nodeIdentifier];
}

@end
