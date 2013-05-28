#import "Game.h"
#import <GLKit/GLKit.h>

@class EAGLView;

@interface GameViewDirector : GLKViewController
{
@public
    RenderManager* renderManager;
}

@property (nonatomic, assign) IBOutlet GLKView* glkView;
@property (nonatomic, assign) IBOutlet ViewLayer* defaultViewLayer;
@property (nonatomic, assign) IBOutlet ViewLayer* statusViewLayer;
@property (nonatomic, assign) IBOutlet ViewLayer* popupViewLayer;
@property (nonatomic, assign) IBOutlet ViewLayer* debugViewLayer;
@property (nonatomic, assign) IBOutlet ViewLayer* loadingViewLayer;

@end
