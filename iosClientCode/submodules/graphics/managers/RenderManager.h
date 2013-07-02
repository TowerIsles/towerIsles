#import "Core.h"
#import "GraphicsBase.h"

@class GLKView;

@interface RenderManager : Manager

- (void)glkView:(GLKView*)view
     drawInRect:(CGRect)rect;

@end
