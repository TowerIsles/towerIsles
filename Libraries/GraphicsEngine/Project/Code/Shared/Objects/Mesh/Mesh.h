#import "RenderResource.h"

typedef enum
{
    MeshTypeMovablePrimitive,
    MeshTypeMovableFile,
    MeshTypeStaticFile
} MeshType;

@interface Mesh : RenderResource
@property (nonatomic, assign) MeshType type;

- (void)createFromVertexData:(float*)vertexData
       vertexDataSizeInBytes:(int)vertexDataSizeInBytes
                   indexData:(int*)indexData
        indexDataSizeInBytes:(int)indexDataSizeInBytes;

- (void)drawBuffers;

@end
