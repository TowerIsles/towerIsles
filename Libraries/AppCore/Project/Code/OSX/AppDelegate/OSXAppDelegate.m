#import "OSXAppDelegate.h"
#import "AppDirector.h"
#import "OpenGLView.h"
#import "AppCoreAsserts.h"

@implementation OSXAppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    [self initializeClassCache];
    
    _director = [AppDirector new];
    
    [self internal_configure];
    
    [_director beginRunning];
}

- (void)internal_configure
{
    [_director configure];
    
    [_director injectManagersIntoIVars:self];
    
    [self configure];
}

- (void)initializeClassCache {}

- (void)configure {}

- (void)registerDrawCallback:(void(^)(OpenGLView*, CGRect))drawCallback
{
    CheckNotNull(_openGLView);
    
    [_openGLView registerDrawCallback:drawCallback];
}

@end
