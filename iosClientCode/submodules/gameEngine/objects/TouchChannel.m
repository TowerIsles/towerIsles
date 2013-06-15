#import "TouchChannel.h"

@interface TouchChannelConfig ()
{
	
}
@end

@implementation TouchChannelConfig
@end



@interface TouchChannel ()
{
	
}
@property (nonatomic, retain) TouchChannelConfig* config;
@property (nonatomic, retain) UIView* viewToObserve;
@end


@implementation TouchChannel

- (void)refresh
{
    _tapGesture.firstFrame = NO;
    if (!_config.manuallyRefreshTap)
    {
        _tapGesture.active = NO;
    }

    _longPressGesture.firstFrame = NO;
    if (!_config.manuallyRefreshLongPress)
    {
        _longPressGesture.active = NO;
    }

    _panGesture.firstFrame = NO;
    if (!_config.manuallyRefreshPan)
    {
        _panGesture.active = NO;
    }
    
    _pinchGesture.firstFrame = NO;
    if (!_config.manuallyRefreshPinch)
    {
        _pinchGesture.active = NO;
    }
    
    if (_config.manualRefreshBlock != nil)
    {
        _config.manualRefreshBlock();
    }
}

- (void)observeTouchesOnView:(UIView*)viewToObserve
                  withConfig:(TouchChannelConfig*)config;
{
    self.config = config;
    self.viewToObserve = viewToObserve;
    
    if (config.observeTap)
    {
        self.tapGesture = [TapGesture object];
        
        [viewToObserve addGestureRecognizer:[[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handleTapFrom:)] autorelease]];
    }

    if (config.observeLongPress)
    {
        self.longPressGesture = [LongPressGesture object];
        
        UILongPressGestureRecognizer* gesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(handleLongPressFrom:)] autorelease];
        
        [viewToObserve addGestureRecognizer:gesture];
        
        // gesture.allowableMovement = 100;
    }
    
    if (config.observePan)
    {
        self.panGesture = [PanGesture object];
        
        [viewToObserve addGestureRecognizer:[[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(handlePanFrom:)] autorelease]];
    }
    
    if (config.observePinch)
    {
        self.pinchGesture = [PinchGesture object];
        
        [viewToObserve addGestureRecognizer:[[[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handlePinchFrom:)] autorelease]];
    }
}

- (void)handleTapFrom:(UITapGestureRecognizer*)gestureRecognizer
{
    CheckNotNull(_tapGesture);
    
    _tapGesture.locationInView = [gestureRecognizer locationInView:_viewToObserve];
    
    _tapGesture.active = YES;
    
    _tapGesture.firstFrame = YES;
}

- (void)handleLongPressFrom:(UILongPressGestureRecognizer*)gestureRecognizer
{
    CheckNotNull(_longPressGesture);
    
    _longPressGesture.locationInView = [gestureRecognizer locationInView:_viewToObserve];
    
    _longPressGesture.active = YES;
    
    _longPressGesture.firstFrame = YES;
}

- (void)handlePinchFrom:(UIPinchGestureRecognizer*)gestureRecognizer
{
    CheckNotNull(_pinchGesture);
    
    _pinchGesture.scale = gestureRecognizer.scale;
    
    _pinchGesture.velocity = gestureRecognizer.velocity;
    
    _pinchGesture.active = YES;
    
    _pinchGesture.firstFrame = gestureRecognizer.state == UIGestureRecognizerStateBegan;
}

- (void)handlePanFrom:(UIPanGestureRecognizer*)gestureRecognizer
{
    CheckNotNull(_panGesture);
  
    _panGesture.locationInView = [gestureRecognizer locationInView:_viewToObserve];
    
    _panGesture.translationInView = [gestureRecognizer translationInView:_viewToObserve];
    
    _panGesture.velocityInView = [gestureRecognizer velocityInView:_viewToObserve];
    
    _panGesture.active = YES;
    
    _panGesture.firstFrame = gestureRecognizer.state == UIGestureRecognizerStateBegan;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    return YES;
}

- (BOOL)                             gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    // Only accept combinations of pan and pinch
    if ([gestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] &&
        [otherGestureRecognizer isKindOfClass:UIPinchGestureRecognizer.class])
        return YES;
    
    if ([otherGestureRecognizer isKindOfClass:UIPanGestureRecognizer.class] &&
        [gestureRecognizer isKindOfClass:UIPinchGestureRecognizer.class])
        return YES;
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer
       shouldReceiveTouch:(UITouch*)touch
{
    return YES;
}

@end
