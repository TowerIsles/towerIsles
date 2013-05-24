#import "EAGLView.h"
#import <QuartzCore/QuartzCore.h>

@implementation EAGLView

+ (Class)layerClass
{
	return [CAEAGLLayer class];
}

@end
