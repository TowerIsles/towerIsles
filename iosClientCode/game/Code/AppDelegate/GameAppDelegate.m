#import "AppDirector.h"
#import "GameAppDelegate.h"
#import "GameViewDirector.h"
#import "ViewManager.h"

@interface GameAppDelegate ()
{
    ViewManager* viewManager;
}
@end

@implementation GameAppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)reload
{
    viewManager = nil;
    
    [_director injectManagersIntoIVars:self];
    
    [self internal_setupViewLayers];
}

+ (GameAppDelegate*)sharedApplicationDelegate
{
    return (GameAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    [self.viewDirector loadView];
    
    if (SystemVersionGreaterThanOrEqualTo(@"6.0"))
        self.window.rootViewController = self.viewDirector;
    else
        [self.window addSubview:self.viewDirector.view];
    
    [_viewDirector.view setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    _director = [AppDirector new];
    
    [self internal_configure];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [_director stopRunning];
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [_director beginRunning];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)internal_configure
{
    [_director configure];
    
    [_director injectManagersIntoIVars:self];
    
    [self internal_setupViewLayers];
}

- (void)internal_setupViewLayers
{
    [viewManager setDefaultViewLayer:_viewDirector.defaultViewLayer];
    
    [viewManager setViewLayer:_viewDirector.statusViewLayer
                    layerName:kStatusViewLayer];
    
    [viewManager setViewLayer:_viewDirector.popupViewLayer
                    layerName:kPopupViewLayer];
    
    [viewManager setViewLayer:_viewDirector.debugViewLayer
                    layerName:kDebugViewLayer];
    
    [viewManager setViewLayer:_viewDirector.loadingViewLayer
                    layerName:kLoadingViewLayer];
    
    [_viewDirector.view setFrame:CGRectMake(0,
                                            0,
                                            [[UIScreen mainScreen] bounds].size.width,
                                            [[UIScreen mainScreen] bounds].size.height)];
}

@end