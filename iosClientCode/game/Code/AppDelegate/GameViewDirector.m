#import "GameViewDirector.h"
#import "NSObject+Object.h"

@implementation GameViewDirector

- (void)dealloc
{
    [GameViewDirector releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

@end