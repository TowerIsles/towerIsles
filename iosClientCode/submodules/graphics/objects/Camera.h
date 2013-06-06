#import "Movable.h"
#import <GLKit/GLKit.h>

@interface CameraConfig : ManagedPropertiesObject
@end

@interface Camera : Movable

- (GLKMatrix4*)getViewMatrix;

@end
