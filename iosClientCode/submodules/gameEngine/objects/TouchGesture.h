#import "Core.h"

@interface TouchGesture : ManagedPropertiesObject
@property (nonatomic, assign, getter=isActive) BOOL active;
@property (nonatomic, assign, getter=isFirstFrame) BOOL firstFrame;
@end

@interface TapGesture : TouchGesture
@property (nonatomic, assign) CGPoint locationInView;
@end

@interface LongPressGesture : TouchGesture
@property (nonatomic, assign) CGPoint locationInView;
@end

@interface PanGesture : TouchGesture
@property (nonatomic, assign) CGPoint locationInView;
@property (nonatomic, assign) CGPoint translationInView;
@property (nonatomic, assign) CGPoint velocityInView;
@property (nonatomic, assign) BOOL hasClick;
@end

@interface PinchGesture : TouchGesture
@property (nonatomic, assign) float scale;
@property (nonatomic, assign) float velocity;
@end