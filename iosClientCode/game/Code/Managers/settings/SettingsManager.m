#import "SettingsManager.h"

@interface SettingsManager ()
{
	
}

@end

@implementation SettingsManager

- (id)init
{
    self = [super init];
    
    if (self != nil)
    {
        _shouldLoginImplicitly = [[BoolSetting objectWithName:@"shouldLoginImplicitly"
                                                 defaultValue:YES] retain];

        _lastLoginId = [[StringSetting objectWithName:@"lastLoginId"
                                         defaultValue:nil] retain];
        
        _lastLoginPassword = [[StringSetting objectWithName:@"lastLoginPassword"
                                               defaultValue:nil] retain];

        //register for user defaults changed notification (for toggling music)
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(defaultsChanged:)
                       name:NSUserDefaultsDidChangeNotification
                     object:nil];
    }
    
    return self;
}

- (void)load
{
    [self applySettings];
}

- (void)applySettings
{
}

- (void)defaultsChanged:(NSNotification*)notification
{
    [self applySettings];
}

@end

