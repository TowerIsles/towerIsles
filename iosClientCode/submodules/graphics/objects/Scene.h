#import "NSObject+Object.h"

@class Identifier;
@class SceneNode;
@class SceneNodeConfig;

@interface SceneConfig : ManagedPropertiesObject
@end

@interface Scene : ManagedPropertiesObject

- (void)configureWithIdentifier:(Identifier*)sceneIdentifier
                    sceneConfig:(SceneConfig*)sceneConfig;

- (SceneNode*)rootSceneNode;

- (SceneNode*)createAndAddSceneNodeWithIdentifer:(Identifier*)nodeIdentifier
                                 sceneNodeConfig:(SceneNodeConfig*)sceneNodeConfig
                            parentNodeIdentifier:(Identifier*)parentNodeIdentifier;

@end
