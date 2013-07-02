#import "CollapsibleModuleViewController.h"
#import "DataEditor.h"

@interface CollapsibleModuleViewController ()
@property (nonatomic, assign) int uncollapsedScrollviewHeight;
@property (nonatomic, assign) BOOL collapsed;
@property (retain) IBOutlet NSButton* collapseBackgroundButton;
- (void)collapse;
- (void)uncollapse;
@end

@implementation CollapsibleModuleViewController
@synthesize removeButton;
@synthesize moveUpButton;
@synthesize moveDownButton;
@synthesize borderBox;
@synthesize collapseButton;
@synthesize collapsed;

+ (NSString*)nibName
{
    return @"CollapsibleModuleView";
}

+ (id)makeModuleCollapsible:(ModuleViewController*)module andAddToOwner:(ModuleViewController*)owner withTitle:(NSString*)aTitle
{
    CollapsibleModuleViewController* instance = [self moduleViewController];
    
    [instance addModuleViewController:module];
    [owner addModuleViewController:instance];
    instance.borderBox.title = aTitle;
    
    
    ModuleViewController* tempOwner = owner;
    int level = 0;
    while([tempOwner isKindOfClass:[ModuleViewController class]])
    {
        tempOwner = tempOwner.owner;
        if ([tempOwner isKindOfClass:[CollapsibleModuleViewController class]])
            ++level;
    }
    
    int indent = instance.docView.frame.origin.x;
    
    NSRect boxFrame = instance.borderBox.frame;
    boxFrame.size.width -= level * indent * 1.4;
    instance.borderBox.frame = boxFrame;
    
    
    if (![instance.owner conformsToProtocol:@protocol(CollapsibleContentOwner)])
    {
        [instance.removeButton setHidden:YES];
        [instance.moveUpButton setHidden:YES];
        [instance.moveDownButton setHidden:YES];
    }
    
    return instance;
}

- (void)dealloc
{
    [CollapsibleModuleViewController releaseRetainedPropertiesOfObject:self];
    
    [super dealloc];
}


- (void)refreshLayout
{
    if (self.collapsed)
        self.view.frameHeight = 24;
    else
        [super refreshLayout];
    
    
    borderBox.frameWidth = self.view.frameWidth;
    borderBox.frameHeight = self.view.frameHeight;
}

- (IBAction)collapseButtonPressed:(NSButton*)sender
{
    if (self.collapsed)
    {
        [self uncollapse];
    }
    else
    {
        [self collapse];
    }
}

- (void)collapse
{
    if (!self.collapsed)
    {
        [borderBox setBorderType:NSNoBorder];
        [_verticalLine removeFromSuperview];
        self.collapsed = YES;
        [self.rootModuleView refreshLayout];
        [self.docView setHidden:YES];
        [collapseButton setState:NSOffState];
    }
}

- (void)uncollapse
{
    if (self.collapsed)
    {
        [borderBox setBorderType:NSBezelBorder];
        [self.view addSubview:_verticalLine];
        self.collapsed = NO;
        [self.rootModuleView refreshLayout];
        [self.docView setHidden:NO];
        [collapseButton setState:NSOnState];
    }
}

- (IBAction)removeButtonAction:(id)sender
{
    [self retain];
    int index = [self.owner indexOfController:self];
    [(id<CollapsibleContentOwner>)self.owner collapsibleContentWillBeRemovedAtIndex:index];
    [[self retain] autorelease];
    [self.owner removeSubviewController:self];
    [self release];
}

- (IBAction)moveUpButtonAction:(id)sender
{
    int index = [self.owner indexOfController:self];
    if (index > 0)
    {
        [(id<CollapsibleContentOwner>)self.owner collapsibleContentWillMoveUpFromIndex:index];
        [self retain];
        [self.owner removeSubviewController:self];
        [self.owner addModuleViewController:self atIndex:index-1];
        [self release];
    }
}

- (IBAction)moveDownButtonAction:(id)sender
{
    int index = [self.owner indexOfController:self];
    if (index < [[self.owner subviewControllers] count] - 1)
    {
        [(id<CollapsibleContentOwner>)self.owner collapsibleContentWillMoveDownFromIndex:index];
        [self retain];
        [self.owner removeSubviewController:self];
        [self.owner addModuleViewController:self atIndex:index+1];
        [self release];
    }
}

@end
