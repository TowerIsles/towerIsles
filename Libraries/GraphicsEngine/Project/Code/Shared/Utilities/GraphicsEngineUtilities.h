#import "GLKit/GLKMatrix3.h"
#import "AppCoreUtilities.h"

@interface Utilities (GraphicsEngine)

+ (void)initializeGraphicsEngineClasses;

+ (void)displayGLKMatrix4:(GLKMatrix4*)matrix
                  context:(NSString*)context;

+ (void)displayGLKMatrix3:(GLKMatrix3*)matrix
                  context:(NSString*)context;

+ (void)displayGLError:(int)error
               context:(NSString*)context;

@end

#if DEBUG
#define CheckGLError                                             \
{                                                                \
    int error = glGetError();                                    \
    if (error != 0)                                              \
    {                                                            \
        [Utilities displayGLError:error                          \
                          context:Format(@"%s", __FUNCTION__)];  \
    }                                                            \
}
#else
#define CheckGLError(contextArg)
#endif

#define BUFFER_OFFSET(i) ((char *)NULL + (i))