#import "Movable.h"
#import "Color.h"

@interface LightConfig : ManagedPropertiesObject
@property (nonatomic, retain) NSString* type;
@property (nonatomic, assign) Color color;
@end

@interface Light : Movable

@end
