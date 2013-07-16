#import "GameAppDelegate.h"
#import "Game.h"

@implementation GameAppDelegate

+ (GameAppDelegate*)sharedApplicationDelegate
{
    return (GameAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)initializeClassCache
{
    [Utilities initializeGameClasses];
}

- (void)configure
{
    [self addViewLayerWithName:@"default"];
    [self addViewLayerWithName:@"status"];
    [self addViewLayerWithName:@"popup"];
    [self addViewLayerWithName:@"debug"];
    [self addViewLayerWithName:@"loading"];
}

@end
