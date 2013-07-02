#ifdef EDITOR

#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glext.h>
#import "GLKit/GLKMatrix3.h"

#define GLKVertexAttribPosition 0
#define GLKVertexAttribNormal 1
#define GLKVertexAttribTexCoord0 2

#else

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

#endif

#import "GLKit/GLKMath.h"

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