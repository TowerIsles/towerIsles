#import "Core.h"

@interface ServerTimeManager : Manager

- (void)setCurrentTimeInMs:(int64_t)currentTimeInMs;

- (int64_t)getCurrentTimeInMs;

@end
