#import "AppCore.h"

#import "GLKit/GLKMath.h"
#import "GraphicsEngineUtilities.h"

#if APP_CORE_OSX

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

