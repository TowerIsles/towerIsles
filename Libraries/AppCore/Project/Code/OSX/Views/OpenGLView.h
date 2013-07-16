#import <Cocoa/Cocoa.h>

@interface OpenGLView : NSOpenGLView

- (void)registerDrawCallback:(void(^)(OpenGLView*, CGRect))drawCallback;

@end
