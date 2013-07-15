#import "NSObject+Object.h"
#import "AppCoreUtilities.h"

@class AppDirector;

@interface Manager : ManagedPropertiesObject

@property (nonatomic, assign) AppDirector* director;

- (int)loadPriority;

- (void)load;

- (void)reload;

- (void)injectConfig:(NSString*)configJsonName;

- (void)registerPreUpdateBlock:(VoidBlock)preUpdateBlock;

- (void)registerInterUpdateBlock:(VoidBlock)interUpdateBlock;

- (void)registerPostUpdateBlock:(VoidBlock)postUpdateBlock;

- (void)registerUpdateBlock:(VoidBlock)updateBlock;

- (void)registerUpdateBlockAtFPS:(int)updatesPerSecond
                     updateBlock:(VoidBlock)updateBlock;

@end
