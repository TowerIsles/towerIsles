#import "NSObject+Object.h"

@interface DisplayLink : ManagedPropertiesObject

+ (DisplayLink*)objectWithOwner:(id)owner
                 updateSelector:(SEL)updateSelector
                  frameInterval:(int)frameInterval;

- (void)invalidate;

@end
