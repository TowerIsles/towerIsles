
@interface FlippedView : NSView

@end


@implementation FlippedView

- (BOOL)isFlipped
{
    return YES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    for(NSView* currentSubview in self.subviews)
    {
        NSRect subviewFrame = currentSubview.frame;
        subviewFrame.origin.y = self.frame.size.height - subviewFrame.origin.y - subviewFrame.size.height;
        currentSubview.frame = subviewFrame;
    }
}

@end
