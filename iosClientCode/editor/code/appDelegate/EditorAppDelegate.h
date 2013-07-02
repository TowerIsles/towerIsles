#import <Cocoa/Cocoa.h>

@class AppDirector;

@interface EditorAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, readonly) AppDirector* director;

+ (EditorAppDelegate*)sharedApplicationDelegate;

@end
