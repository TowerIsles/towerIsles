#import "Light.h"

@implementation LightConfig

+ (void)setupSerialization
{
    DeserializationHandler_Color(LightConfig, color, _color);
}

@end

@interface Light ()
{
	
}

@end


@implementation Light


@end
