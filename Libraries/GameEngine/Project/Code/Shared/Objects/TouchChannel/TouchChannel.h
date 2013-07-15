#import "AppCore.h"
#import "TouchGesture.h"

@interface TouchChannelConfig : ManagedPropertiesObject
@property (nonatomic, assign) BOOL observeTap;
@property (nonatomic, assign) BOOL observeLongPress;
@property (nonatomic, assign) BOOL observePan;
@property (nonatomic, assign) BOOL observePinch;
@property (nonatomic, assign) BOOL manuallyRefreshTap;
@property (nonatomic, assign) BOOL manuallyRefreshLongPress;
@property (nonatomic, assign) BOOL manuallyRefreshPan;
@property (nonatomic, assign) BOOL manuallyRefreshPinch;
@property (nonatomic, copy) VoidBlock manualRefreshBlock;
@end

@interface TouchChannel : ManagedPropertiesObject

@property (nonatomic, retain) TapGesture* tapGesture;
@property (nonatomic, retain) LongPressGesture* longPressGesture;
@property (nonatomic, retain) PanGesture* panGesture;
@property (nonatomic, retain) PinchGesture* pinchGesture;

- (void)refresh;

- (void)observeTouchesOnView:(id)viewToObserve
                  withConfig:(TouchChannelConfig*)config;

@end
