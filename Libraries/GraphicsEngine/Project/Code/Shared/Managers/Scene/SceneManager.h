#import "Manager.h"
#import "GraphicsBase.h"

@class Scene;
@class SceneConfig;

@interface SceneManager : Manager

- (Scene*)createSceneWithIdentifier:(Identifier*)sceneIdentifier
                        sceneConfig:(SceneConfig*)sceneConfig;

- (Scene*)sceneForConfig:(Identifier*)sceneIdentifier;

- (Scene*)getActiveScene;

- (void)setActiveScene:(Scene*)scene;

- (void)renderActiveScene;

@end
