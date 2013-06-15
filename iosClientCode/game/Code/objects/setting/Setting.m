#import "Setting.h"

@interface StringSetting ()
@property (nonatomic, retain) NSString* defaultValue;
@end

@implementation StringSetting

+ (StringSetting*)objectWithName:(NSString*)name
                    defaultValue:(NSString*)defaultValue
{
    StringSetting* stringSetting = [StringSetting object];
    stringSetting.name = name;
    stringSetting.defaultValue = defaultValue;
    return stringSetting;
}

- (NSString*)getSettingValue
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_name] != nil)
    {
        return [[NSUserDefaults standardUserDefaults] stringForKey:_name];
    }
    else
    {
        return _defaultValue;
    }
}

- (void)setSettingValue:(NSString*)settingValue
{
    [[NSUserDefaults standardUserDefaults] setObject:settingValue
                                              forKey:_name];
}

- (void)clearSetting
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_name];
}

@end

@interface BoolSetting ()
@property (nonatomic, assign) BOOL defaultValue;
@end

@implementation BoolSetting

+ (BoolSetting*)objectWithName:(NSString*)name
                  defaultValue:(BOOL)defaultValue
{
    BoolSetting* boolSetting = [BoolSetting object];
    boolSetting.name = name;
    boolSetting.defaultValue = defaultValue;
    return boolSetting;
}

- (BOOL)getSettingValue
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_name] != nil)
    {
        return [[NSUserDefaults standardUserDefaults] boolForKey:_name];
    }
    else
    {
        return _defaultValue;
    }
}

- (void)setSettingValue:(BOOL)settingValue
{
    [[NSUserDefaults standardUserDefaults] setBool:settingValue
                                            forKey:_name];
}

- (void)clearSetting
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_name];
}

@end

@interface FloatSetting()
@property (nonatomic, assign) float defaultValue;
@property (nonatomic, copy) VoidBlock mutationOccurredBlock;
@end

@implementation FloatSetting

+ (FloatSetting*)objectWithName:(NSString*)name
                   defaultValue:(float)defaultValue
{
    FloatSetting* floatSetting = [FloatSetting object];
    floatSetting.name = name;
    floatSetting.defaultValue = defaultValue;
    return floatSetting;
}

- (void)addMutationOccurredBlock:(VoidBlock)mutationOccurredBlock
{
    self.mutationOccurredBlock = mutationOccurredBlock;
}

- (float)getSettingValue
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:_name] != nil)
    {
        return [[NSUserDefaults standardUserDefaults] floatForKey:_name];
    }
    else
    {
        return _defaultValue;
    }
}

- (void)setSettingValue:(float)settingValue
{
    if ([self getSettingValue] != settingValue)
    {
        [[NSUserDefaults standardUserDefaults] setFloat:settingValue
                                                 forKey:_name];
        
        _mutationOccurredBlock();
    }
}

- (void)clearSetting
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:_name];
}

@end