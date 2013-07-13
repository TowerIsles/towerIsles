#import <Foundation/Foundation.h>
#import "NSObject+Serialization.h"

@interface ManagedPropertiesObject : NSObject
@end

@interface NSObject (Object)

+ (id)object;

+ (void)releaseRetainedPropertiesOfObject:(id)object;

@end
