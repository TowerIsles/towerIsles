#import "UpdateBlockAtInterval.h"

@class Manager;

@interface AppDirector : NSObject

- (void)configure;

- (void)stopRunning;

- (void)beginRunning;

- (void)reload;

- (void)registerPreUpdateBlock:(VoidBlock)preUpdateBlock;

- (void)registerInterUpdateBlock:(VoidBlock)interUpdateBlock;

- (void)registerPostUpdateBlock:(VoidBlock)postUpdateBlock;

- (void)registerUpdateBlock:(VoidBlock)updateBlock;

- (void)registerUpdateBlockAtFPS:(int)updatesPerSecond
                     updateBlock:(VoidBlock)updateBlock;

- (void)injectManagersIntoIVars:(id)injectee;

- (id)managerForClass:(Class)managerClass;

@end
