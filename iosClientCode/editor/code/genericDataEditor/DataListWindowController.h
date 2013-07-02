#import <Cocoa/Cocoa.h>

@protocol DataListWindowDelegate <NSObject>

- (void)updateDataList;

- (void)editDataWithIdentifier:(NSString*)identifier;

- (void)deleteDataWithIdentifier:(NSString*)identifier;

- (void)duplicateDataWithIdentifier:(NSString*)identifier
                      newIdentifier:(NSString*)newIdentifier;

- (void)newDataWithIdentifier:(NSString*)identifier;

- (void)renameDataWithIdentifier:(NSString*)identifier
                   newIdentifier:(NSString*)newIdentifier;

@end


@interface DataListWindowController : NSWindowController <NSTableViewDataSource,NSTableViewDelegate,NSTextFieldDelegate>

@property (nonatomic, retain) NSArray* allIdentifiers;

+ (id)dataListWindowControllerWithTitle:(NSString*)title
                           listDelegate:(id<DataListWindowDelegate>)listDelegate;

- (void)reloadData;

- (IBAction)updateDataList:(id)sender;

@end
