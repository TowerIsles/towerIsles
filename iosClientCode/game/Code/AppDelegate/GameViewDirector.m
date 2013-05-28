#import "GameViewDirector.h"
#import "NSObject+Object.h"

@implementation GameViewDirector

- (void)dealloc
{
    [GameViewDirector releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)glkView:(GLKView*)view
     drawInRect:(CGRect)rect
{
    [renderManager glkView:view
                drawInRect:rect];
}

@end