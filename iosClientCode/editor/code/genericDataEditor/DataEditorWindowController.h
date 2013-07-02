#import "Utilities.h"

@class ModuleViewController;

@interface DataEditorWindowController : NSWindowController
@property (nonatomic, retain, readonly) ModuleViewController* baseModuleViewController;
@property (nonatomic, copy) VoidBlock saveBlock;

+ (id)dataEditorWindowControllerWithTitle:(NSString*)title
                           willCloseBlock:(VoidBlock)willCloseBlock
                                saveBlock:(VoidBlock)saveBlock;

@end
