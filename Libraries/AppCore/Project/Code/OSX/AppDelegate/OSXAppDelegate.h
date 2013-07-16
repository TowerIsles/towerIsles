#import <Cocoa/Cocoa.h>

@class AppDirector;
@class OpenGLView;

@interface OSXAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (nonatomic, retain) IBOutlet NSWindow* window;
@property (nonatomic, retain) IBOutlet OpenGLView* openGLView;
@property (nonatomic, readonly) AppDirector* director;

- (void)initializeClassCache;

- (void)configure;

- (void)registerDrawCallback:(void(^)(OpenGLView*, CGRect))drawCallback;

@end
