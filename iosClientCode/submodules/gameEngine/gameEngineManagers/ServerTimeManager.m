#import "ServerTimeManager.h"

@interface ServerTimeManager ()
{
    int64_t _serverTimeInMsAtConfiguration;
    NSTimeInterval _localTimeAtConfigurationTimeInSec;
    int64_t _predictedCurrentTimeInMs;
    NSTimeInterval _lastRefreshTimeInSec;
}
@end

@implementation ServerTimeManager

- (void)load
{
    [self.director registerPreUpdateBlock:^{
        [self internal_refreshPredictedServerTimeWithCurrentMediaTimeSec:CACurrentMediaTime()];
    }];
}

- (void)setCurrentTimeInMs:(int64_t)currentTimeInMs
{
    _serverTimeInMsAtConfiguration = currentTimeInMs;
    
    _localTimeAtConfigurationTimeInSec = CACurrentMediaTime();
    
    [self internal_refreshPredictedServerTimeWithCurrentMediaTimeSec:_localTimeAtConfigurationTimeInSec];
}

- (int64_t)getCurrentTimeInMs
{
    NSTimeInterval currentMediaTimeInSec = CACurrentMediaTime();
    
    if (currentMediaTimeInSec - _lastRefreshTimeInSec > 1)
    {
        [self internal_refreshPredictedServerTimeWithCurrentMediaTimeSec:currentMediaTimeInSec];
    }

    return _predictedCurrentTimeInMs;
}

- (void)internal_refreshPredictedServerTimeWithCurrentMediaTimeSec:(NSTimeInterval)currentMediaTimeInSec
{
    NSTimeInterval timeInSecSinceConfiguration = currentMediaTimeInSec - _localTimeAtConfigurationTimeInSec;
    
    _predictedCurrentTimeInMs = _serverTimeInMsAtConfiguration + (int64_t)(timeInSecSinceConfiguration * 1000.0);
}

@end
