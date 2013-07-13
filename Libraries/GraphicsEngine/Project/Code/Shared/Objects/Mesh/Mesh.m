#import "Mesh.h"
#import "GraphicsBase.h"

@interface Mesh ()
{
    GLuint _vertexBufferHandle;
    GLuint _indexBufferHandle;
}
@property (nonatomic, assign) float* vertexData;
@property (nonatomic, assign) int vertexDataSizeInBytes;

@property (nonatomic, assign) int* indexData;
@property (nonatomic, assign) int indexDataSizeInBytes;
@end

@implementation Mesh

- (void)createFromVertexData:(float*)vertexData
       vertexDataSizeInBytes:(int)vertexDataSizeInBytes
                   indexData:(int*)indexData
        indexDataSizeInBytes:(int)indexDataSizeInBytes
{
    self.vertexData = vertexData;
    self.vertexDataSizeInBytes = vertexDataSizeInBytes;
    self.indexData = indexData;
    self.indexDataSizeInBytes = indexDataSizeInBytes;
    
    glGenBuffers(1, &_vertexBufferHandle);
    glGenBuffers(1, &_indexBufferHandle);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferHandle);
    glBufferData(GL_ARRAY_BUFFER, _vertexDataSizeInBytes, _vertexData, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferHandle);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indexDataSizeInBytes, _indexData, GL_STATIC_DRAW);
    
    CheckGLError
}

- (void)prepareForRender
{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferHandle);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBufferHandle);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
    
    CheckGLError
}

- (void)drawBuffers
{
    glDrawArrays(GL_TRIANGLE_STRIP, 0, _vertexDataSizeInBytes / sizeof(GL_FLOAT));
    
    CheckGLError
}

@end
