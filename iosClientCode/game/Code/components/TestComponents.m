#import "TestComponents.h"

@implementation TestComponentOne

- (void)dealloc
{
	[TestComponentOne releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

@end


@implementation TestComponentTwo

- (void)dealloc
{
	[TestComponentTwo releaseRetainedPropertiesOfObject:self];
	[super dealloc];
}

@end

