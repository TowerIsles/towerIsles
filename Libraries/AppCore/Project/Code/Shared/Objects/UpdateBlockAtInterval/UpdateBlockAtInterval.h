#import "NSObject+Object.h"
#import "AppCoreUtilities.h"

@interface UpdateBlockAtInterval : ManagedPropertiesObject

+ (UpdateBlockAtInterval*)objectWithUpdateBlock:(VoidBlock)updateBlock
                               updatesPerSecond:(int)updatesPerSecond
                               currentTimeInSec:(NSTimeInterval)currentTimeInMSec;

- (void)updateAtCurrentTimeInSec:(NSTimeInterval)currentTimeInSec;

@end
