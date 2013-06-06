#import "Movable.h"
#import <GLKit/GLKit.h>

@class Camera;
@class Node;

@interface Renderable : Movable

- (void)renderWithCamera:(Camera*)camera;

@end
