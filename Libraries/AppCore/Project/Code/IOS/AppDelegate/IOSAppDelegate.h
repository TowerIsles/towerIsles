#import <UIKit/UIKit.h>

@class ViewDirector;
@class AppDirector;
@class ViewLayer;
@class GLKView;

@interface IOSAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, readonly) AppDirector* director;

- (void)addViewLayerWithName:(NSString*)viewLayerName;

- (void)initializeClassCache;

- (void)configure;

- (void)registerDrawCallback:(void(^)(GLKView*, CGRect))drawCallback;

@end
