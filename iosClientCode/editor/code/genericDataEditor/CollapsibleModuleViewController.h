#import "ModuleViewController.h"


@interface CollapsibleModuleViewController : ModuleViewController
@property (retain) IBOutlet NSButton *removeButton;
@property (retain) IBOutlet NSButton *moveUpButton;
@property (retain) IBOutlet NSButton *moveDownButton;
@property (retain) IBOutlet NSBox *borderBox;
@property (retain) IBOutlet NSButton *collapseButton;
@property (retain) IBOutlet NSView* verticalLine;

+ (id)makeModuleCollapsible:(ModuleViewController*)module andAddToOwner:(ModuleViewController*)owner withTitle:(NSString*)aTitle;
- (IBAction)collapseButtonPressed:(id)sender;

- (IBAction)removeButtonAction:(id)sender;
- (IBAction)moveUpButtonAction:(id)sender;
- (IBAction)moveDownButtonAction:(id)sender;

- (void)collapse;

@end




@protocol CollapsibleContentOwner <NSObject>

- (void)collapsibleContentWillBeRemovedAtIndex:(int)index;
- (void)collapsibleContentWillMoveUpFromIndex:(int)index;
- (void)collapsibleContentWillMoveDownFromIndex:(int)index;

@end
