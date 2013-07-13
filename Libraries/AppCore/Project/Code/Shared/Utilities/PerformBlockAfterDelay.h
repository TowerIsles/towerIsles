#import "AppCoreUtilities.h"

void incrementDelayedBlockContext();

int currentDelayedBlockContext();

static inline void performBlockAfterDelay(NSTimeInterval delay, VoidBlock block)
{
    int callContext = currentDelayedBlockContext();
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        if (callContext == currentDelayedBlockContext())
        {
            block();
        }
#if DEBUG
        else
        {
            NSLog(@"performBlockAfterDelay - block not called! block context has been incremented");
        }
#endif
    });
}