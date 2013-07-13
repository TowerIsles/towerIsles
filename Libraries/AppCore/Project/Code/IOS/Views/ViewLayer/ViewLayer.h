#import <UIKit/UIKit.h>

@class ManagedView;

@interface ViewLayer : NSObject

@property (nonatomic, assign) IBOutlet UIView* view;

- (void)showManagedView:(ManagedView*)managedView
             setupBlock:(void(^)(ManagedView*))setupBlock;

- (void)dismissManagedView:(ManagedView*)managedView;

- (void)dismissAllViews;

@end
