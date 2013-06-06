#import "NSObject+Object.h"

@class Identifier;
@class SceneNode;
@class SceneNodeConfig;

@interface SceneConfig : ManagedPropertiesObject
@end

@interface Scene : ManagedPropertiesObject

+ (Scene*)objectWithIdentifier:(Identifier*)sceneIdentifier
                   sceneConfig:(SceneConfig*)sceneConfig;

- (SceneNode*)rootSceneNode;

- (SceneNode*)cameraOneNode;

- (SceneNode*)createAndAddSceneNodeWithIdentifer:(Identifier*)nodeIdentifier
                                 sceneNodeConfig:(SceneNodeConfig*)sceneNodeConfig
                            parentNodeIdentifier:(Identifier*)parentNodeIdentifier;

- (void)renderVisibleNodes;

@end
