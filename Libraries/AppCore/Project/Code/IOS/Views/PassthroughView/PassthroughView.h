#import <UIKit/UIKit.h>

@interface PassthroughView : UIView

- (UIView*)hitTest:(CGPoint)point
         withEvent:(UIEvent*)event;

@end

@interface PassthroughLabel : UILabel

- (UIView*)hitTest:(CGPoint)point
         withEvent:(UIEvent*)event;

@end
