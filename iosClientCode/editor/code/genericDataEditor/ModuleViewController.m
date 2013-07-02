#import "ModuleViewController.h"
#import "Utilities.h"
#import "DataEditor.h"
#import "DataEditor.h"
#import "CollapsibleModuleViewController.h"
#import "EditorAppDelegate.h"
//#import "Director.h"

int getDataEditorShouldStripFormulas();

static NSString* moduleViewControllerCurrentMode = @"Default";

@interface GenericNibContainer : ModuleViewController
@end

@implementation GenericNibContainer
@end

@interface GenericTextFieldNibContainer : GenericNibContainer
@property (nonatomic, retain) IBOutlet NSTextField* textField;
@property (nonatomic, retain) IBOutlet NSTextField* label;
@end

@implementation GenericTextFieldNibContainer

+ (NSString*)nibName
{
    return @"GenericTextField";
}

- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor
{
    return YES;
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    return YES;
}

//- (void)controlTextDidChange:(NSNotification *)aNotification
//{
//    if ([aNotification object] == self.textField)
//    {
//        NSDictionary* info = [self.textField infoForBinding:@"value"];
//        NSString* keypath = [info objectForKey:NSObservedKeyPathKey];
//        id object = [info objectForKey:NSObservedObjectKey];
//        NSString* value = self.textField.stringValue;
//        [object setValue:value
//              forKeyPath:keypath];
//    }
//}

@end


@interface GenericTextViewNibContainer : GenericNibContainer <NSTextViewDelegate>
@property (nonatomic, retain) IBOutlet NSTextView* textView;
@property (nonatomic, retain) IBOutlet NSTextField* label;
@end

@implementation GenericTextViewNibContainer

//- (void)textDidChange:(NSNotification *)notification
//{
//    NSDictionary* info = [self.textView infoForBinding:@"value"];
//    NSString* keypath = [info objectForKey:NSObservedKeyPathKey];
//    id object = [info objectForKey:NSObservedObjectKey];
//    NSString* value = self.textView.string;
//    [object setValue:value
//          forKeyPath:keypath];
//}

+ (NSString*)nibName
{
    return @"GenericTextView";
}

@end


@interface GenericCheckBoxNibContainer : GenericNibContainer
@property (nonatomic, retain) IBOutlet NSButton* checkBox;
@end

@implementation GenericCheckBoxNibContainer

+ (NSString*)nibName
{
    return @"GenericCheckBox";
}

@end

@interface GenericImageNibContainer : GenericNibContainer
@property (nonatomic, retain) IBOutlet NSImageView* image;
@property (nonatomic, retain) IBOutlet NSComboBox* comboBox;
@property (nonatomic, retain) IBOutlet NSTextField* label;
@property (nonatomic, assign) BOOL collapsed;

- (void)useImagePath:(NSString*)path;
- (IBAction)collapseButtonPressed:(NSButton*)sender;

@end

@implementation GenericImageNibContainer

- (IBAction)collapseButtonPressed:(NSButton*)sender
{
    _collapsed ? [self uncollapse] : [self collapse];
}

- (void)uncollapse
{
    self.collapsed = NO;
    [_image setFrameHeight:128];
    [_image setFrameY:0];
//    [self.view setFrameHeight:153];
}

- (void)collapse
{
    self.collapsed = YES;
    [_image setFrameHeight:20];
    [_image setFrameY:108];
//    [self.view setFrameHeight:50];
}

- (void)useImagePath:(NSString*)path
{
    NSString* pathToUse = path;
    
    if (![pathToUse hasSuffix:@".png"])
    {
        pathToUse = Format(@"%@.png", pathToUse);
    }
//    TODO
//    Director* director = [[((AppDelegate*)[[NSApplication sharedApplication] delegate]) editor] director];
//
//    NSImage* image = [[[NSImage alloc] initWithContentsOfFile:[director pathForResource:pathToUse]] autorelease];
//    [self.image setImage:image];
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    NSString* stringContext = (NSString*)context;
    if ([stringContext isEqualToString:@"imageToLoad"])
    {
        [self useImagePath:[change objectForKey:@"new"]];
    }
}

+ (NSString*)nibName
{
    return @"GenericImageView";
}

@end

@interface GenericComboBoxNibContainer : GenericNibContainer
@property (nonatomic, retain) IBOutlet NSComboBox* comboBox;
@property (nonatomic, retain) IBOutlet NSTextField* label;

@end

@implementation GenericComboBoxNibContainer

//- (void)controlTextDidChange:(NSNotification *)aNotification
//{
//    if ([aNotification object] == self.comboBox)
//    {
//        NSDictionary* info = [self.comboBox infoForBinding:@"value"];
//        NSString* keypath = [info objectForKey:NSObservedKeyPathKey];
//        id object = [info objectForKey:NSObservedObjectKey];
//        NSString* value = self.comboBox.stringValue;
//        [object setValue:value
//              forKeyPath:keypath];
//    }
//}

+ (NSString*)nibName
{
    return @"GenericComboBox";
}

@end



@interface ModuleViewController ()
@property (nonatomic, retain) id value;
@property (nonatomic, retain) NSView* lastAddedGenericView;

@end


@implementation ModuleViewController

+ (NSString*)nibName
{
    return @"ModuleView";
}

+ (id)moduleViewController
{
    return [[[self alloc] initWithNibName:[self nibName]
                                   bundle:nil] autorelease];
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self != nil)
    {
        _subviewControllers = [NSMutableArray new];
        _modeString = @"Default";
        [self loadView];
        
        self.baseHeight = self.view.frameHeight;
    }
    
    return self;
}

- (void)dealloc
{
    self.modeChangeBlock = nil;
    [ModuleViewController releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)awakeFromNib
{
    self.view.autoresizesSubviews = NO;
    self.docView.autoresizesSubviews = NO;
}

- (ModuleViewController*)rootModuleView
{
    if (self.owner == nil)
        return self;
    else
        return [self.owner rootModuleView];
}

- (void)notifyShouldCommitIntermediateValues
{
    if (_commitIntermediateValuesBlock != nil)
        _commitIntermediateValuesBlock();
    
    for (ModuleViewController* subviewController in self.subviewControllers)
    {
        [subviewController notifyShouldCommitIntermediateValues];
    }
}

- (void)refreshRootLayout
{
    [self.rootModuleView refreshLayout];
}

- (void)refreshLayout
{
    int y = 0;
    
    for (ModuleViewController* subviewController in self.subviewControllers)
    {
        [subviewController refreshLayout];
        
        subviewController.view.frameY = y;
        
        y += subviewController.view.frameHeight;
    }
    
    self.view.frameHeight = y + self.baseHeight;
    self.docView.frameHeight = y;
}

- (void)addModuleViewController:(ModuleViewController*)viewController
{
    [self addModuleViewController:viewController
                          atIndex:(int)_subviewControllers.count];
}

- (void)addModuleViewController:(ModuleViewController*)viewController
                        atIndex:(int)index
{
    CheckTrue(self.docView != nil);
    CheckTrue(self.docView != self.view);
    
    viewController.owner = self;
    
    [self.docView addSubview:viewController.view];
    [_subviewControllers insertObject:viewController
                                   atIndex:index];
    
    [viewController setup];
    
    [self.rootModuleView refreshLayout];
}


- (void)removeSubviewController:(ModuleViewController*)viewController
{
    [viewController teardown];
    viewController.commitIntermediateValuesBlock = nil;
    
    [viewController.view removeFromSuperview];
    [_subviewControllers removeObject:viewController];
    
    [self.rootModuleView refreshLayout];
}

- (void)removeAllSubviewControllers
{
    while ([self.subviewControllers count])
    {
        [self removeSubviewController:[self.subviewControllers lastObject]];
    }
}

- (int)indexOfController:(ModuleViewController*)viewController
{
    return (int)[_subviewControllers indexOfObject:viewController];
}

- (void)setup
{
}

- (void)teardown
{
}


+ (id)moduleViewControllerWithValue:(id)value
{
    ModuleViewController* moduleViewController = [ModuleViewController moduleViewController];
    moduleViewController.value = value;
    return moduleViewController;
}

- (NSString*)baseKeypath
{
    return @"value.";
}

- (void)addTextFieldWithValueBinding:(NSString*)valueBindingKeyPath
                              inMode:(NSString*)mode
{
    [self addTextFieldWithTitle:nil
                    placeholder:nil
                   valueBinding:valueBindingKeyPath
                         inMode:mode];
}

- (void)addTextFieldWithTitle:(NSString*)title
                 valueBinding:(NSString*)valueBindingKeyPath
                       inMode:(NSString*)mode
{
    [self addTextFieldWithTitle:title
                    placeholder:nil
                   valueBinding:valueBindingKeyPath
                         inMode:mode];
}

- (void)addTextFieldWithTitle:(NSString*)title
                  placeholder:(NSString*)placeholder
                 valueBinding:(NSString*)valueBindingKeyPath
                       inMode:(NSString*)mode
{
    if (![self modeAllowed:mode])
        return;
    
    if (title == nil)
        title = [valueBindingKeyPath stringByConvertingCamelCaseToCapitalizedWords];
    
    if (placeholder == nil)
        placeholder = @"";
    
    GenericTextFieldNibContainer* container = [GenericTextFieldNibContainer moduleViewController];
    
    [container.textField bind:@"value"
                     toObject:self
                  withKeyPath:[self.baseKeypath stringByAppendingString:valueBindingKeyPath]
                      options:nil];
    
    [container.label setStringValue:title];
    [[container.textField cell] setPlaceholderString:placeholder];
    
    [self.lastAddedGenericView setNextKeyView:container.textField];
    self.lastAddedGenericView = container.textField;
    
    [self addModuleViewController:container];
}



- (void)setValue:(id)value
      forKeyPath:(NSString *)keyPath
{
    if (value == nil)
        return;
        
    if ([keyPath isEqualToString:@"modeString"])
    {
        self.modeString = value;
        moduleViewControllerCurrentMode = value;
        if (_modeChangeBlock != nil)
        {
            performBlockAfterDelay(0, _modeChangeBlock);
        }
    }
    else
    {
        [super setValue:value
             forKeyPath:keyPath];
    }
}

- (NSString*)currentMode
{
    return moduleViewControllerCurrentMode;
}

- (BOOL)modeAllowed:(NSString*)mode
{
    if (([[self currentMode] isEqualToString:@"Default"] ||
        [[self currentMode] isEqualToString:mode] ||
        mode == nil))
        return YES;
    return NO;
}

- (void)addTextViewWithValueBinding:(NSString*)valueBindingKeyPath
                             inMode:(NSString*)mode
{
    [self addTextViewWithTitle:nil
                  valueBinding:valueBindingKeyPath
                        inMode:mode];
}

- (void)addTextViewWithTitle:(NSString*)title
                valueBinding:(NSString*)valueBindingKeyPath
                      inMode:(NSString*)mode
{
    if (![self modeAllowed:mode])
        return;
    
    if (title == nil)
        title = [valueBindingKeyPath stringByConvertingCamelCaseToCapitalizedWords];
    
    GenericTextViewNibContainer* container = [GenericTextViewNibContainer moduleViewController];
    
    [container.textView bind:@"value"
                    toObject:self
                 withKeyPath:[self.baseKeypath stringByAppendingString:valueBindingKeyPath]
                     options:nil];
    
    [container.label setStringValue:title];
    
    [self addModuleViewController:container];
}

- (void)addComboBoxWithValueBinding:(NSString*)valueBinding
                     possibleValues:(NSArray*)possibleValues
                             inMode:(NSString*)mode
{
    [self addComboBoxWithTitle:nil
                   placeholder:nil
                  valueBinding:valueBinding
                possibleValues:possibleValues
                        inMode:mode];
}

- (void)addComboBoxWithTitle:(NSString*)title
                valueBinding:(NSString*)valueBinding
              possibleValues:(NSArray*)possibleValues
                      inMode:(NSString*)mode
{
    [self addComboBoxWithTitle:title
                   placeholder:nil
                  valueBinding:valueBinding
                possibleValues:possibleValues
                        inMode:mode];
}

- (NSComboBox*)addComboBoxWithTitle:(NSString*)title
                   initialSelection:(NSString*)selection
                             inMode:(NSString*)mode
{
    if (![self modeAllowed:mode])
        return nil;
        
    if (title == nil)
        title = @"";
    
    GenericComboBoxNibContainer* container = [GenericComboBoxNibContainer moduleViewController];
        
    [self.lastAddedGenericView setNextKeyView:container.comboBox];
    self.lastAddedGenericView = container.comboBox;
    
    [self addModuleViewController:container];    
    
    container.comboBox.numberOfVisibleItems = 40;
    if(selection)
    {
        [container.comboBox selectItemWithObjectValue:selection];
    }
    
    return container.comboBox;
}

- (void)addComboBoxWithTitle:(NSString*)title
                 placeholder:(NSString*)placeholder
                valueBinding:(NSString*)valueBinding
              possibleValues:(NSArray*)possibleValues
                      inMode:(NSString*)mode
{
    if (![self modeAllowed:mode])
        return;
    
    if (placeholder == nil)
        placeholder = @"";
    
    if (title == nil)
        title = [valueBinding stringByConvertingCamelCaseToCapitalizedWords];
    
    GenericComboBoxNibContainer* container = [GenericComboBoxNibContainer moduleViewController];
    
    [container.comboBox bind:@"value"
                    toObject:self
                 withKeyPath:[self.baseKeypath stringByAppendingString:valueBinding]
                     options:nil];
    
    [container.comboBox addItemsWithObjectValues:possibleValues];
    container.comboBox.numberOfVisibleItems = 40;
    [container.label setStringValue:title];
    [[container.comboBox cell] setPlaceholderString:placeholder];
    
    [self.lastAddedGenericView setNextKeyView:container.comboBox];
    self.lastAddedGenericView = container.comboBox;
    
    [self addModuleViewController:container];
}

- (void)addCheckBoxWithValueBinding:(NSString*)valueBindingKeyPath
                             inMode:(NSString*)mode
{
    [self addCheckBoxWithTitle:nil
                  valueBinding:valueBindingKeyPath
                        inMode:mode];
}

- (void)addCheckBoxWithTitle:(NSString*)title
                valueBinding:(NSString*)valueBindingKeyPath
                      inMode:(NSString*)mode
{
    if (![self modeAllowed:mode])
        return;
    
    if (title == nil)
        title = [valueBindingKeyPath stringByConvertingCamelCaseToCapitalizedWords];
    
    GenericCheckBoxNibContainer* container = [GenericCheckBoxNibContainer moduleViewController];
    
    [container.checkBox bind:@"value"
                    toObject:self
                 withKeyPath:[self.baseKeypath stringByAppendingString:valueBindingKeyPath]
                     options:nil];
    
    [container.checkBox setTitle:title];
    
    [self.lastAddedGenericView setNextKeyView:container.checkBox];
    self.lastAddedGenericView = container.checkBox;
    
    [self addModuleViewController:container];
}

- (void)addCollapsibleModuleViewController:(ModuleViewController*)viewController
                                     title:(NSString*)title
                        initiallyCollapsed:(BOOL)collapsed
                                    inMode:(NSString*)mode
{
    if (![self modeAllowed:mode])
        return;
    
    CollapsibleModuleViewController* collapsibleViewController = [CollapsibleModuleViewController makeModuleCollapsible:viewController
                                                                                                          andAddToOwner:self
                                                                                                              withTitle:title];
    
    if (collapsed)
        [collapsibleViewController performSelector:@selector(collapse)];
}

- (void)addImageWithTitle:(NSString*)title
             valueBinding:(NSString*)valueBindingKeyPath
           possibleValues:(NSArray*)possibleValues
                   inMode:(NSString*)mode
{
    if (![self modeAllowed:mode])
        return;
    
    GenericImageNibContainer* container = [GenericImageNibContainer moduleViewController];
    
    [container.label setStringValue:title];
    
    [container.comboBox addItemsWithObjectValues:possibleValues];
    container.comboBox.numberOfVisibleItems = 40;
    
    NSString* keyPath = [self.baseKeypath stringByAppendingString:valueBindingKeyPath];
    
    [self addObserver:container
           forKeyPath:keyPath
              options:NSKeyValueObservingOptionNew
              context:@"imageToLoad"];
    
    [container useImagePath:[self valueForKeyPath:keyPath]];
    
    [container.comboBox bind:@"value"
                    toObject:self
                 withKeyPath:keyPath
                     options:nil];
    
    [self.lastAddedGenericView setNextKeyView:container.comboBox];
    self.lastAddedGenericView = container.comboBox;
    
    [self addModuleViewController:container];
}

@end



@implementation NSView (FrameConvenience)

- (void)setFrameWidth:(CGFloat)frameWidth
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x,
                            frame.origin.y,
                            frameWidth,
                            frame.size.height);
}

- (void)setFrameHeight:(CGFloat)frameHeight
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x,
                            frame.origin.y,
                            frame.size.width,
                            frameHeight);
}

- (void)setFrameX:(CGFloat)frameX
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frameX,
                            frame.origin.y,
                            frame.size.width,
                            frame.size.height);
}

- (void)setFrameY:(CGFloat)frameY
{
    CGRect frame = self.frame;
    self.frame = CGRectMake(frame.origin.x,
                            frameY,
                            frame.size.width,
                            frame.size.height);
}

- (CGFloat)frameX
{
    return self.frame.origin.x;
}

- (CGFloat)frameY
{
    return self.frame.origin.y;
}

- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

@end



