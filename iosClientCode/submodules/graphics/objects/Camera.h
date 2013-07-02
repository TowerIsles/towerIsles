#import "Movable.h"
#import "GLKit/GLKMatrix4.h"
#import "Vec3.h"

@interface CameraConfig : ManagedPropertiesObject
@end

@interface Camera : Movable

- (GLKMatrix4*)getViewMatrix;

- (void)lookAt:(Vec3)targetLocation;

- (void)setDirection:(Vec3)direction;

@end
