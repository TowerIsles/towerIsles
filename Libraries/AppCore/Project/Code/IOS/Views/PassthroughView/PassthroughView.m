#import "PassthroughView.h"
#import "NSObject+Object.h"

@implementation PassthroughView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (UIView*)hitTest:(CGPoint)point
         withEvent:(UIEvent*)event
{
	UIView* hit = [super hitTest:point
                       withEvent:event];
	
    return hit == self ? nil : hit;
}

@end

@implementation PassthroughLabel

- (UIView*)hitTest:(CGPoint)point
         withEvent:(UIEvent*)event
{
	UIView* hit = [super hitTest:point
                       withEvent:event];
	
    return hit == self ? nil : hit;
}

@end