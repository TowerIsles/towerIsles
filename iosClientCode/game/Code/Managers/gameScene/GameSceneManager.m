#import "GameSceneManager.h"
#import "NodeSpec.h"
#import "NodeComponent.h"
#import "Identifier.h"

@interface GameSceneManager ()
{
    SceneManager* sceneManager;
}
@property (nonatomic, retain) NSMutableDictionary* scenesByIdentifier;
@property (nonatomic, assign) BOOL nextSceneNodeIdentifier;
@end


@implementation GameSceneManager

- (Scene*)internal_sceneForIdentifier:(Identifier*)sceneIdentifier
{
    CheckNotNull([_scenesByIdentifier objectForKey:sceneIdentifier]);
    
    return [_scenesByIdentifier objectForKey:sceneIdentifier];
}

- (void)addNodeSpecsToSceneWithIdentifier:(Identifier*)sceneIdentifier
                                nodeSpecs:(NSArray*)nodeSpecs
{
    CheckNotNull(sceneIdentifier);
    CheckNotNull(nodeSpecs);
    
    Scene* scene = [self internal_sceneForIdentifier:sceneIdentifier];
    
    for (NodeSpec* nodeSpec in nodeSpecs)
    {
        for (SceneNodeConfig* sceneNodeConfig in nodeSpec->nodeComponent.sceneNodeConfigs)
        {
            SceneNode* sceneNode = [scene createAndAddSceneNodeWithIdentifer:[Identifier objectWithIntIdentifier:_nextSceneNodeIdentifier++]
                                                             sceneNodeConfig:sceneNodeConfig
                                                        parentNodeIdentifier:nil];
            
            [nodeSpec->nodeComponent.sceneNodes addObject:sceneNode];
            
        }
    }
}

@end
