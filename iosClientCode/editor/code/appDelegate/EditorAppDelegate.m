#import "EditorAppDelegate.h"
#import "AppDirector.h"

@implementation EditorAppDelegate

+ (EditorAppDelegate*)sharedApplicationDelegate
{
    return [NSApp delegate];
}

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [Util initializeCachedClasses];
    
    _director = [AppDirector new];
    
    [self internal_configure];
}

- (void)internal_configure
{
    [_director configure];
    
    [_director injectManagersIntoIVars:self];
    
    [self internal_setupViews];
}

- (void)internal_setupViews
{
    
}

@end
