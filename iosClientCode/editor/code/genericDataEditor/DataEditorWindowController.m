#import "DataEditorWindowController.h"
#import "DataEditor.h"


@interface DataEditorWindowController ()  <NSTextFieldDelegate, NSWindowDelegate>
@property (assign) IBOutlet NSScrollView* scrollView;
@property (nonatomic, copy) VoidBlock willCloseBlock;
@property (nonatomic, retain) ModuleViewController* baseModuleViewController;
@end

@implementation DataEditorWindowController

- (void)dealloc
{
    [DataEditorWindowController releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

+ (id)dataEditorWindowControllerWithTitle:(NSString*)title
                           willCloseBlock:(VoidBlock)willCloseBlock
                                saveBlock:(VoidBlock)saveBlock
{    
    DataEditorWindowController* editWindowController = [[[DataEditorWindowController alloc] initWithWindowNibName:@"DataEditorWindow"] autorelease];
    editWindowController.willCloseBlock = willCloseBlock;
    
    editWindowController.saveBlock = ^
    {
        [editWindowController.baseModuleViewController notifyShouldCommitIntermediateValues];
        saveBlock();
    };
    
    [editWindowController loadWindow];
    editWindowController.window.title = title;
    
    editWindowController.baseModuleViewController = [ModuleViewController moduleViewController];
    editWindowController.baseModuleViewController.owner = nil;
    editWindowController.baseModuleViewController.rootView = editWindowController.window.contentView;
    editWindowController.baseModuleViewController.baseHeight = 24;
    
    [editWindowController.scrollView setDocumentView:editWindowController.baseModuleViewController.view];
    
    return editWindowController;
}


- (BOOL)windowShouldClose:(id)sender
{
    [self.baseModuleViewController notifyShouldCommitIntermediateValues];
    _willCloseBlock();
    
    return YES;
}

@end
