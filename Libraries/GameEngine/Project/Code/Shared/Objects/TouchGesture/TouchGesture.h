#import "NSObject+Object.h"
#import "Vec2.h"

// Create point class.

@interface TouchGesture : ManagedPropertiesObject
@property (nonatomic, assign, getter=isActive) BOOL active;
@property (nonatomic, assign, getter=isFirstFrame) BOOL firstFrame;
@end

@interface TapGesture : TouchGesture
@property (nonatomic, assign) Vec2 locationInView;
@end

@interface LongPressGesture : TouchGesture
@property (nonatomic, assign) Vec2 locationInView;
@end

@interface PanGesture : TouchGesture
@property (nonatomic, assign) Vec2 locationInView;
@property (nonatomic, assign) Vec2 translationInView;
@property (nonatomic, assign) Vec2 velocityInView;
@property (nonatomic, assign) BOOL hasClick;
@end

@interface PinchGesture : TouchGesture
@property (nonatomic, assign) float scale;
@property (nonatomic, assign) float velocity;
@end