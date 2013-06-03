#import "RenderResource.h"

typedef enum
{
    MeshTypeMovablePrimitive,
    MeshTypeMovableFile,
    MeshTypeStaticFile
} MeshType;

@interface Mesh : RenderResource
@property (nonatomic, assign) MeshType type;

- (void)createFromData:(float*)data
              dataSize:(int)dataSize;

- (int)vertexCount;

@end
