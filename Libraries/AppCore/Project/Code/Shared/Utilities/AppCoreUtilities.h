
#define SystemVersionGreaterThanOrEqualTo(version)                                                          \
    ([[[UIDevice currentDevice] systemVersion] compare:version                                              \
                                               options:NSNumericSearch] != NSOrderedAscending)

#define Format(format...) [NSString stringWithFormat:format]
#define Float(x) [NSNumber numberWithFloat:x]
#define Bool(x) [NSNumber numberWithBool:x]
#define Integer(x) [NSNumber numberWithInt:x]
#define Dictionary(args...) [NSMutableDictionary dictionaryWithObjectsAndKeys:args, nil]

typedef void (^VoidBlock)();

extern Class kArrayClass;
extern Class kMutableArrayClass;
extern Class kDictionaryClass;
extern Class kMutableDictionaryClass;
extern Class kStringClass;
extern Class kMutableStringClass;
extern Class kNumberClass;
extern Class kObjectClass;
extern Class kManagerClass;
extern Class kManagedPropertiesObjectClass;
extern Class kBasicSerializedClassesPlaceholderClass;
extern Class kManagedViewClass;

@interface Utilities : NSObject

+ (void)initializeAppCoreClasses;

+ (NSArray*)allClassesWithSuperClass:(Class)superClass;

+ (NSString*)formatDate:(NSDate*)date;

+ (void)addNewEntriesOfSourceDictionary:(NSDictionary*)source
                     toTargetDictionary:(NSMutableDictionary*)target;

+ (void)removeDefaultValuesFromDictionary:(NSMutableDictionary*)dictionary;

+ (float)randomFloatBetween0And1;

+ (float)randomFloatBetweenMin:(float)min
                           max:(float)max;

+ (int)randomIntBetweenMin:(int)min
                       max:(int)max;

@end
