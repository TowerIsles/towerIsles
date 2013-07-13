#import "PerformBlockAfterDelay.h"

int blockContext = 0;

void incrementDelayedBlockContext()
{
    ++blockContext;
}

int currentDelayedBlockContext()
{
    return blockContext;
}
