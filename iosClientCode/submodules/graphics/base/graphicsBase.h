#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#define PrintGLErrorStr(er) \
{\
if (er == 1286)\
{\
printf("INVALID_FRAMEBUFFER_OPERATION\n");\
}\
else if (er == 1280)\
{\
printf("GL_INVALID_ENUM\n");\
}\
else if (er == 1281)\
{\
printf("GL_INVALID_VALUE\n");\
}\
else if (er == 1282)\
{\
printf("GL_INVALID_OPERATION\n");\
}\
else if (er == 1283)\
{\
printf("GL_STACK_OVERFLOW\n");\
}\
else if (er == 1284)\
{\
printf("GL_STACK_UNDERFLOW\n");\
}\
else if (er == 1285)\
{\
printf("GL_OUT_OF_MEMORY\n");\
}\
else if (er == 32817)\
{\
printf("GL_TABLE_TOO_LARGE\n");\
}\
}\


#if defined(DEBUG) && !ENGINE_MAC
#define CheckGLError { int _gl_err = glGetError(); if (_gl_err != 0) { printf("\n\nGL ERROR %d:  ", _gl_err); PrintGLErrorStr(_gl_err); printf("\n\n"); AssertNow(); } }
#else
#define CheckGLError
#endif