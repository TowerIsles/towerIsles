#import "Game.h"
#import "Setting.h"

@interface SettingsManager : Manager

@property (nonatomic, retain) BoolSetting* shouldLoginImplicitly;
@property (nonatomic, retain) StringSetting* lastLoginId;
@property (nonatomic, retain) StringSetting* lastLoginPassword;

- (void)applySettings;

@end
