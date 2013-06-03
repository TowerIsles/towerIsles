#import "Mesh.h"
#import "GraphicsBase.h"

@interface Mesh ()
{
    GLuint _vertexHandle;
}
@property (nonatomic, assign) float* data;
@property (nonatomic, assign) int dataSize;
@property (nonatomic, assign) int calculatedVertexCount;
@end

@implementation Mesh

- (void)createFromData:(float*)data
              dataSize:(int)dataSize
{
    self.data = data;
    self.dataSize = dataSize;
    self.calculatedVertexCount = dataSize / sizeof(GL_FLOAT);
    glGenBuffers(1, &_vertexHandle);
}

- (void)prepareForRender
{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexHandle);
    glBufferData(GL_ARRAY_BUFFER, _dataSize, _data, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
    
}

- (int)vertexCount
{
    return _calculatedVertexCount;
}

@end
