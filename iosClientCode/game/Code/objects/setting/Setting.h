#import "Game.h"

@interface StringSetting : ManagedPropertiesObject
@property (nonatomic, retain) NSString* name;

+ (StringSetting*)objectWithName:(NSString*)name
                    defaultValue:(NSString*)defaultValue;

- (NSString*)getSettingValue;

- (void)setSettingValue:(NSString*)settingValue;

- (void)clearSetting;

@end

@interface BoolSetting : ManagedPropertiesObject
@property (nonatomic, retain) NSString* name;

+ (BoolSetting*)objectWithName:(NSString*)name
                  defaultValue:(BOOL)defaultValue;

- (BOOL)getSettingValue;

- (void)setSettingValue:(BOOL)settingValue;

- (void)clearSetting;

@end

@interface FloatSetting : ManagedPropertiesObject
@property (nonatomic, retain) NSString* name;

+ (FloatSetting*)objectWithName:(NSString*)name
                   defaultValue:(float)defaultValue;

- (void)addMutationOccurredBlock:(VoidBlock)mutationOccurredBlock;

- (float)getSettingValue;

- (void)setSettingValue:(float)settingValue;

- (void)clearSetting;

@end