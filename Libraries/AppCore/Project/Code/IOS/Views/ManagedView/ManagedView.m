#import "ManagedView.h"
#import "ViewLayer.h"
#import "NSObject+Object.h"

#define kFadeOutTime 0.3f

@interface ManagedView ()
{
	
}
@property (nonatomic, copy) VoidBlock updateBlock;
@property (nonatomic, retain) NSTimer* updateBlockTimer;
@property (nonatomic, assign) ViewLayer* viewLayer;
@property (nonatomic, assign) IBOutlet UIView* managedView;
@end


@implementation ManagedView

+ (ManagedView*)createManagedViewWithClass:(Class)managedViewClass
                                    parent:(id)parent
{
    NSString* managedViewName = NSStringFromClass(managedViewClass);
    
    ManagedView* managedView = [managedViewClass object];
    managedView.parent = parent;
    
    if (SystemVersionGreaterThanOrEqualTo( @"4.0" ))
    {
        id nib = [UINib performSelector:@selector(nibWithNibName:bundle:)
                             withObject:managedViewName
                             withObject:[NSBundle mainBundle]];
          
		if (nib != nil)
		{
            @try
            {
                [nib performSelector:@selector(instantiateWithOwner:options:)
                          withObject:managedView
                          withObject:nil];
            }
            @catch (NSException* e)
            {
                NSLog(@"[NIB] ERROR BINDING VIEW CONTROLLER: %@", e);
            }
		}
		else
		{
			NSLog(@"Failed to load nib: %@", managedViewName);
		}
    }
    else
    {
        [[NSBundle mainBundle] loadNibNamed:managedViewName
                                      owner:managedView
                                    options:0];
    }
    
    return managedView;;
}

- (void)setViewLayer:(ViewLayer*)viewLayer
{
    _viewLayer = viewLayer;
}

- (UIView*)managedUIView
{
    return _managedView;
}

- (CGPoint)locationInHighestParentView
{
    id parent = self.parent;
    CGPoint currentLocationOfSelfInParent = [self.managedUIView frame].origin;
    if ([parent isKindOfClass:kManagedViewClass])
    {
        ManagedView* managedViewParent = (ManagedView*)parent;
        CGPoint parentLocation = [managedViewParent locationInHighestParentView];
        currentLocationOfSelfInParent = CGPointMake(parentLocation.x + currentLocationOfSelfInParent.x,
                                                    parentLocation.y + currentLocationOfSelfInParent.y);
    }
    else
    {
        UIView* uiView = self.managedUIView;
        while (uiView != nil)
        {
            CGPoint uiViewLocation = uiView.frame.origin;
            currentLocationOfSelfInParent = CGPointMake(uiViewLocation.x + currentLocationOfSelfInParent.x,
                                                        uiViewLocation.y + currentLocationOfSelfInParent.y);
            uiView = uiView.superview;
        }
    }
    return currentLocationOfSelfInParent;
}

- (void)sizeToScreen
{
    self.managedView.frame = _viewLayer.view.bounds;
}

- (void)viewWillShow {}

- (void)viewWillFadeOut {}

- (void)fadeIn
{
    [self fadeInAlpha];
}

- (void)fadeOut
{
    [self fadeOutAlpha];
}

- (void)dismiss
{
    [_viewLayer dismissManagedView:self];
}

- (void)bringSubviewToFront
{
    [_viewLayer.view bringSubviewToFront:_managedView];
}

// Fades
- (void)fadeInAlpha
{
    self.managedView.alpha = 0;
    [UIView animateWithDuration:kFadeOutTime
                     animations:^{
                         self.managedView.alpha = 1;
                     }];
}

- (void)fadeOutAlpha
{
    [self internal_prepareFadeOut];
    [UIView animateWithDuration:kFadeOutTime
                     animations:^{
                         self.managedView.alpha = 0;
                     }
                     completion:^(BOOL complete) {
                         [self internal_finalizeFadeOut];
                     }];
}

- (void)fadeInSlideUp
{
    self.managedUIView.transform = CGAffineTransformMakeTranslation(0, self.managedUIView.frame.size.height);
    [UIView animateWithDuration:kFadeOutTime
                     animations:^{
                         self.managedUIView.transform = CGAffineTransformMakeTranslation(0, 0);
                     }];
}

- (void)fadeOutSlideDown
{
    [self internal_prepareFadeOut];
    [UIView animateWithDuration:kFadeOutTime
                     animations:^{
                         self.managedUIView.transform = CGAffineTransformMakeTranslation(0, self.managedUIView.frame.size.height);
                     }
                     completion:^(BOOL complete) {
                         [self internal_finalizeFadeOut];
                     }];
}

- (void)internal_prepareFadeOut
{
    [self viewWillFadeOut];
    
    [self.managedView setUserInteractionEnabled:NO];
}

- (void)internal_finalizeFadeOut
{
    self.parent = nil;
    [self.managedUIView removeFromSuperview];
}

- (void)internal_performUpdateBlock
{
    _updateBlock();
}

- (void)performUpdateBlockAtInterval:(NSTimeInterval)interval
                         updateBlock:(VoidBlock)updateBlock
{
    self.updateBlock = updateBlock;
    
    [_updateBlockTimer invalidate];
    
    self.updateBlockTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                             target:self
                                                           selector:@selector(internal_performUpdateBlock)
                                                           userInfo:nil
                                                            repeats:YES];
    
    [self internal_performUpdateBlock];
}

@end
