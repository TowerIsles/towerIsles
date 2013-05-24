#import "Game.h"

@class EAGLView;

@interface GameViewDirector : UIViewController

@property (nonatomic, assign) IBOutlet EAGLView* eaglView;
@property (nonatomic, assign) IBOutlet ViewLayer* defaultViewLayer;
@property (nonatomic, assign) IBOutlet ViewLayer* statusViewLayer;
@property (nonatomic, assign) IBOutlet ViewLayer* popupViewLayer;
@property (nonatomic, assign) IBOutlet ViewLayer* debugViewLayer;
@property (nonatomic, assign) IBOutlet ViewLayer* loadingViewLayer;

@end
