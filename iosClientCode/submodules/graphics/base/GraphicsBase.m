#import "GraphicsBase.h"

void displayGLKMatrix4(NSString* name, GLKMatrix4* matrix)
{
    NSLog(@"GLKMatrix4 = %@", name);
    NSLog(@"%f, %f, %f, %f", matrix->m00, matrix->m01, matrix->m02, matrix->m03);
    NSLog(@"%f, %f, %f, %f", matrix->m10, matrix->m11, matrix->m12, matrix->m13);
    NSLog(@"%f, %f, %f, %f", matrix->m20, matrix->m21, matrix->m22, matrix->m23);
    NSLog(@"%f, %f, %f, %f", matrix->m30, matrix->m31, matrix->m32, matrix->m33);
}

void displayGLKMatrix3(NSString* name, GLKMatrix3* matrix)
{
    NSLog(@"GLKMatrix3 = %@", name);
    NSLog(@"%f, %f, %f", matrix->m00, matrix->m01, matrix->m02);
    NSLog(@"%f, %f, %f", matrix->m10, matrix->m11, matrix->m12);
    NSLog(@"%f, %f, %f", matrix->m20, matrix->m21, matrix->m22);
}

void displayGLError(int error)
{
    NSLog(@"\n\nGL ERROR %d:  ", error);
    
    switch (error)
    {
        case 1286:
            NSLog(@"INVALID_FRAMEBUFFER_OPERATION\n");
            break;
        case 1280:
            NSLog(@"GL_INVALID_ENUM\n");
            break;
        case 1281:
            NSLog(@"GL_INVALID_VALUE\n");
            break;
        case 1282:
            NSLog(@"GL_INVALID_OPERATION\n");
            break;
        case 1283:
            NSLog(@"GL_STACK_OVERFLOW\n");
            break;
        case 1284:
            NSLog(@"GL_STACK_UNDERFLOW\n");
            break;
        case 1285:
            NSLog(@"GL_OUT_OF_MEMORY\n");
            break;
        case 32817:
            NSLog(@"GL_TABLE_TOO_LARGE\n");
            break;
        default:
            NSLog(@"OpenGL Error = %d", error);
    }
    NSLog(@"\n\n");
}