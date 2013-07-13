#import "UpdateBlockAtInterval.h"
#import "AppCoreAsserts.h"

@interface UpdateBlockAtInterval ()
{
	
}
@property (nonatomic, copy) VoidBlock updateBlock;
@property (nonatomic, assign) NSTimeInterval lastUpdateTimeInSec;
@property (nonatomic, assign) NSTimeInterval timeBetweenUpdateInSec;
@end

@implementation UpdateBlockAtInterval

+ (UpdateBlockAtInterval*)objectWithUpdateBlock:(VoidBlock)updateBlock
                               updatesPerSecond:(int)updatesPerSecond
                               currentTimeInSec:(NSTimeInterval)currentTimeInSec
{
    UpdateBlockAtInterval* updateBlockAtInterval = [UpdateBlockAtInterval object];
    updateBlockAtInterval.updateBlock = updateBlock;
    updateBlockAtInterval.timeBetweenUpdateInSec = 1.f / updatesPerSecond;
    updateBlockAtInterval.lastUpdateTimeInSec = currentTimeInSec - updateBlockAtInterval.timeBetweenUpdateInSec;
    return updateBlockAtInterval;
}

- (void)updateAtCurrentTimeInSec:(NSTimeInterval)currentTimeInSec
{
    NSTimeInterval timeSinceLastUpdate = currentTimeInSec - _lastUpdateTimeInSec;
    if (timeSinceLastUpdate >= _timeBetweenUpdateInSec)
    {
        _lastUpdateTimeInSec = currentTimeInSec - MIN(_timeBetweenUpdateInSec, timeSinceLastUpdate - _timeBetweenUpdateInSec);
        _updateBlock();
    }
}

@end
