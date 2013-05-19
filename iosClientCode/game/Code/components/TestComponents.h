#import "Game.h"

@interface TestComponentOne : Component <SerializeByDefault>
@property (nonatomic, assign) int testParamOne;
@property (nonatomic, assign) float testParamTwo;
@end


@interface TestComponentTwo : Component <SerializeByDefault>
@property (nonatomic, assign) int testParamOne;
@property (nonatomic, assign) float testParamTwo;
@end

