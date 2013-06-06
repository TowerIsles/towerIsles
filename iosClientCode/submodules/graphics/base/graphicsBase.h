#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>
#import "Asserts.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

void displayGLKMatrix4(NSString* name, GLKMatrix4* matrix);

void displayGLKMatrix3(NSString* name, GLKMatrix3* matrix);

void displayGLError(int error);

#if DEBUG

#define CheckGLError                    \
{                                       \
    int error = glGetError();           \
    if (error != 0)                     \
    {                                   \
        displayGLError(error);          \
        AssertNow();                    \
    }                                   \
}

#else
#define CheckGLError
#endif