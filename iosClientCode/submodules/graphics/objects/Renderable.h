#import "Movable.h"

@class Camera;
@class Node;

@interface Renderable : Movable

- (void)renderWithCamera:(Camera*)camera;

@end
