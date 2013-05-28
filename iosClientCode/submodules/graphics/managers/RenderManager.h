#import "Core.h"
#import "GraphicsBase.h"

@interface RenderManager : Manager

- (void)glkView:(GLKView*)view
     drawInRect:(CGRect)rect;

@end
