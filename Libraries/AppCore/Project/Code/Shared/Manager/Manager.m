#import "Manager.h"
#import "AppDirector.h"
#import "ResourceManager.h"

@implementation Manager

- (int)loadPriority  { return 0; }

- (void)load {}

- (void)reload {}

- (void)injectConfig:(NSString*)configJsonName
{
    @autoreleasepool
    {
        [self setValuesWithSerializedRepresentation:[ResourceManager configurationObjectForResourceInBundleWithName:configJsonName
                                                                                                         usingClass:kDictionaryClass]];
    }
}

- (void)registerPreUpdateBlock:(VoidBlock)preUpdateBlock
{
    [self.director registerPreUpdateBlock:preUpdateBlock];
}

- (void)registerInterUpdateBlock:(VoidBlock)interUpdateBlock
{
    [self.director registerInterUpdateBlock:interUpdateBlock];
}

- (void)registerPostUpdateBlock:(VoidBlock)postUpdateBlock
{
    [self.director registerPostUpdateBlock:postUpdateBlock];
}

- (void)registerUpdateBlock:(VoidBlock)updateBlock
{
    [self.director registerUpdateBlock:updateBlock];
}

- (void)registerUpdateBlockAtFPS:(int)updatesPerSecond
                     updateBlock:(VoidBlock)updateBlock
{
    [self.director registerUpdateBlockAtFPS:updatesPerSecond
                                updateBlock:updateBlock];
}

@end
