#import "FPSCounter.h"
#import "FrameTimeManager.h"

@interface FPSCounter ()
{
    FrameTimeManager* frameTimeManager;
}

@property (nonatomic, assign) IBOutlet UILabel* fpsLabel;

@end


@implementation FPSCounter

- (void)dealloc
{
	[FPSCounter releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

- (void)viewWillShow
{
    [self performUpdateBlockAtInterval:1.0f
                           updateBlock:^{
                               _fpsLabel.text = Format(@"%.1f", frameTimeManager.currentFPS);
                           }];
}

@end
