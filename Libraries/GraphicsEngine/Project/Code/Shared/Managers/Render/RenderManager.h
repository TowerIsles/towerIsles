#import "GraphicsBase.h"

@class GLKView;
@class OpenGLView;

@interface RenderManager : Manager

- (void)glkView:(GLKView*)view
     drawInRect:(CGRect)rect;

- (void)openGLView:(OpenGLView*)view
        drawInRect:(CGRect)rect;


@end
