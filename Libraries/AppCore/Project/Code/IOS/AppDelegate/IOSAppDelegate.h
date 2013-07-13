#import <UIKit/UIKit.h>

@class ViewDirector;
@class AppDirector;
@class ViewLayer;

@interface IOSAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, readonly) AppDirector* director;

- (void)addViewLayerWithName:(NSString*)viewLayerName;

- (void)configure;

@end
