#import "Game.h"

@class Light;
@class LightConfig;

@interface LightComponent : Component

@property (nonatomic, retain) Light* light;
@property (nonatomic, retain) LightConfig* lightConfig;
@property (nonatomic, assign) int nodeIndex;

@end