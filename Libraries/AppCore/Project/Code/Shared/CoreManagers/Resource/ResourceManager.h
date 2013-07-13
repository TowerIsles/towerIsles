#import "Manager.h"

@interface ResourceManager : Manager

+ (BOOL)doesResourceAtPathExist:(NSString*)resourceName;

+ (NSString*)formatPathForResourceInBundleWithName:(NSString*)resourceName;

+ (id)configurationObjectForResourceAtPath:(NSString*)resourceName
                                usingClass:(Class)configurationClass;

+ (id)configurationObjectForResourceInBundleWithName:(NSString*)resourceName
                                          usingClass:(Class)configurationClass;

@end
