#import <GLKit/GLKit.h>

@interface ViewDirector : GLKViewController

- (GLKView*)getOpenGLView;

- (void)setDrawCallback:(void(^)(GLKView*, CGRect))drawCallback;

- (void)addUIView:(UIView*)uiView;

- (void)initOpenGLContext;

@end
