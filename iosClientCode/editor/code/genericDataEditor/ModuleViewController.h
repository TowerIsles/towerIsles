#import "Utilities.h"

@interface ModuleViewController : NSViewController

@property (nonatomic, retain) NSMutableArray* subviewControllers;
@property (assign) ModuleViewController* owner;
@property (retain) NSView* rootView;
@property (nonatomic, retain) IBOutlet NSView* docView;
@property (nonatomic, assign) float baseHeight;
@property (nonatomic, retain) NSString* modeString;
@property (nonatomic, copy) VoidBlock modeChangeBlock;

@property (nonatomic, copy) VoidBlock commitIntermediateValuesBlock;
@property (nonatomic, readonly, assign) NSView* lastKeyView;
@property (nonatomic, readonly, assign) NSView* nextKeyView;

- (ModuleViewController*)rootModuleView;

+ (id)moduleViewController;
+ (id)moduleViewControllerWithValue:(id)value;

- (void)notifyShouldCommitIntermediateValues;

- (void)addModuleViewController:(ModuleViewController*)viewController;

- (void)removeSubviewController:(ModuleViewController*)viewController;

- (void)removeAllSubviewControllers;

- (int)indexOfController:(ModuleViewController*)viewController;

- (void)addModuleViewController:(ModuleViewController*)viewController
                         atIndex:(int)index;

- (void)setup;
- (void)teardown;

- (void)refreshLayout;

+ (NSString*)nibName;

- (void)addTextFieldWithValueBinding:(NSString*)valueBindingKeyPath
                              inMode:(NSString*)mode;

- (void)addTextFieldWithTitle:(NSString*)title
                  placeholder:(NSString*)placeholder
                 valueBinding:(NSString*)valueBindingKeyPath
                       inMode:(NSString*)mode;

- (void)addTextFieldWithTitle:(NSString*)title
                 valueBinding:(NSString*)valueBindingKeyPath
                       inMode:(NSString*)mode;


- (void)addComboBoxWithTitle:(NSString*)title
                 placeholder:(NSString*)placeholder
                valueBinding:(NSString*)valueBinding
              possibleValues:(NSArray*)possibleValues
                      inMode:(NSString*)mode;

- (NSComboBox*)addComboBoxWithTitle:(NSString*)title
                   initialSelection:(NSString*)selection
                             inMode:(NSString*)mode;

- (void)addComboBoxWithTitle:(NSString*)title
                valueBinding:(NSString*)valueBinding
              possibleValues:(NSArray*)possibleValues
                      inMode:(NSString*)mode;

- (void)addComboBoxWithValueBinding:(NSString*)valueBinding
                     possibleValues:(NSArray*)possibleValues
                             inMode:(NSString*)mode;

- (void)addCheckBoxWithTitle:(NSString*)title
                valueBinding:(NSString*)valueBindingKeyPath
                      inMode:(NSString*)mode;

- (void)addCheckBoxWithValueBinding:(NSString*)valueBindingKeyPath
                             inMode:(NSString*)mode;

- (void)addCollapsibleModuleViewController:(ModuleViewController*)viewController
                                     title:(NSString*)title
                        initiallyCollapsed:(BOOL)collapsed
                                    inMode:(NSString*)mode;

- (void)addTextViewWithTitle:(NSString*)title
                valueBinding:(NSString*)valueBindingKeyPath
                      inMode:(NSString*)mode;

- (void)addTextViewWithValueBinding:(NSString*)valueBindingKeyPath
                             inMode:(NSString*)mode;

- (void)addImageWithTitle:(NSString*)title
             valueBinding:(NSString*)valueBindingKeyPath
           possibleValues:(NSArray*)possibleValues
                   inMode:(NSString*)mode;

@end




@interface NSView (FrameConvenience)

@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGFloat frameX;
@property (nonatomic, assign) CGFloat frameY;

@end

void swizzleFormulaSerializationHandler();