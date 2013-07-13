#import "RenderResource.h"
#import "Color.h"

@interface Material : RenderResource

+ (Material*)objectWithColor:(Color)color;

@end
