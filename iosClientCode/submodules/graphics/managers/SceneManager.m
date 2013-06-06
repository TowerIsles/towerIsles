#import "SceneManager.h"
#import "Scene.h"

@interface SceneManager ()
{
	
}
@property (nonatomic, retain) Scene* activeScene;
@property (nonatomic, retain) NSMutableDictionary* sceneForIdentifier;
@end

@implementation SceneManager

- (id)init
{
    if (self = [super init])
    {
        _sceneForIdentifier = [NSMutableDictionary new];
    }
    return self;
}

- (Scene*)createSceneWithIdentifier:(Identifier*)sceneIdentifier
                        sceneConfig:(SceneConfig*)sceneConfig
{
    CheckNotNull(sceneIdentifier);
    CheckNotNull(sceneConfig);
    CheckTrue([_sceneForIdentifier objectForKey:sceneIdentifier] == nil);
    
    Scene* scene = [Scene objectWithIdentifier:sceneIdentifier
                                   sceneConfig:sceneConfig];
    
    [_sceneForIdentifier setObject:scene
                            forKey:sceneIdentifier];
    
    return scene;
}

- (Scene*)sceneForConfig:(Identifier*)sceneIdentifier
{
    return [_sceneForIdentifier objectForKey:sceneIdentifier];
}

- (void)setActiveScene:(Scene*)scene
{
    if (scene != _activeScene)
    {
        [_activeScene release];
        _activeScene = [scene retain];
    }
}

- (void)renderActiveScene
{
    [_activeScene renderVisibleNodes];
}


@end
