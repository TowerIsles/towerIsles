#import "AppCoreUtilities.h"
#import <UIKit/UIKit.h>

@class AppDirector;
@class ViewLayer;

@interface ManagedView : UIResponder

@property (nonatomic, assign) AppDirector* director;
@property (nonatomic, assign) id parent;

+ (ManagedView*)createManagedViewWithClass:(Class)managedViewClass
                                    parent:(id)parent;

- (void)setViewLayer:(ViewLayer*)viewLayer;

- (UIView*)managedUIView;

- (CGPoint)locationInHighestParentView;

- (void)sizeToScreen;

- (void)viewWillShow;

- (void)viewWillFadeOut;

- (void)fadeIn;

- (void)fadeOut;

- (void)fadeInAlpha;

- (void)fadeOutAlpha;

- (void)fadeInSlideUp;

- (void)fadeOutSlideDown;

- (void)dismiss;

- (void)bringSubviewToFront;

- (void)performUpdateBlockAtInterval:(NSTimeInterval)interval
                         updateBlock:(VoidBlock)updateBlock;

@end
