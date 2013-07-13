#import "Material.h"
#import "GraphicsBase.h"

@interface Material ()
{
    GLuint _textureHandle;
}

@end


@implementation Material

- (void)prepareForRender
{
    glBindTexture(GL_TEXTURE_2D, _textureHandle);
    
    CheckGLError
}

+ (Material*)objectWithColor:(Color)color
{
    Material* material = [Material object];
    
    // Generate texture
    unsigned int r = ColorUnsignedR(&color);
    unsigned int g = ColorUnsignedG(&color);
    unsigned int b = ColorUnsignedB(&color);
    unsigned int a = ColorUnsignedA(&color);
    
    GLubyte textureData[] = {r,g,b,a,
                             r,g,b,a,
                             r,g,b,a,
                             r,g,b,a};
    
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &material->_textureHandle);
    glBindTexture(GL_TEXTURE_2D, material->_textureHandle);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 2, 2, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    CheckGLError
    
    return material;
}

@end
