#import "Game.h"

@interface FrameTimeManager : Manager

- (int)currentFrameNumber;

- (float)lastFrameTimeInSec;

- (float)currentFPS;

@end
