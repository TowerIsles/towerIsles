#import "Base.h"

@class AppDirector;
@class GameViewDirector;

@interface GameAppDelegate : UIResponder <UIApplicationDelegate>

- (void)reload;

+ (GameAppDelegate*)sharedApplicationDelegate;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, assign) IBOutlet GameViewDirector* viewDirector;
@property (nonatomic, readonly) AppDirector* director;

@end
