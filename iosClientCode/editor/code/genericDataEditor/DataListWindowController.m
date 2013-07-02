#import "DataListWindowController.h"
#import "DataEditor.h"

@interface DataListWindowController ()
@property (nonatomic, retain) NSMutableArray* autocompletedIndices;
@property (nonatomic, copy) NSString* currentSubstring;
@property (nonatomic, copy) NSString* attemptingActionType;
@property (nonatomic, copy) NSString* currentIdentifier;
@property (nonatomic, retain) NSString* currentlySelectedIdentifier;
@property (nonatomic, assign) id<DataListWindowDelegate> listDelegate;
@property (assign) IBOutlet NSTableView *dataListTable;
@property (assign) IBOutlet NSTextField *searchTextField;
@property (assign) IBOutlet NSTextField *identifierTextField;
@property (assign) IBOutlet NSButton *createNewButton;
@property (assign) IBOutlet NSButton *duplicateButton;
@property (assign) IBOutlet NSButton *deleteButton;
@end

@implementation DataListWindowController
@synthesize allIdentifiers;
@synthesize identifierTextField;
@synthesize createNewButton;
@synthesize duplicateButton;
@synthesize deleteButton;
@synthesize dataListTable;
@synthesize searchTextField;
@synthesize autocompletedIndices;
@synthesize currentlySelectedIdentifier;
@synthesize currentSubstring;
@synthesize attemptingActionType;
@synthesize currentIdentifier;
@synthesize listDelegate;

+ (id)dataListWindowControllerWithTitle:(NSString*)title
                           listDelegate:(id<DataListWindowDelegate>)listDelegate
{
    DataListWindowController* dataListWindowController = [[self alloc] initWithWindowNibName:@"DataListWindow"];
    
    dataListWindowController.listDelegate = listDelegate;
    [dataListWindowController loadWindow];
    dataListWindowController.window.title = title;
    
    [dataListWindowController searchAutocompleteEntriesWithSubstring:nil];
    
    [dataListWindowController.dataListTable setTarget:dataListWindowController];
    [dataListWindowController.dataListTable setDoubleAction:@selector(tableDoubleClick:)];
    
    return [dataListWindowController autorelease];
}

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    
    if (self != nil)
    {
        autocompletedIndices = [NSMutableArray new];
    }
    
    return self;
}

- (void)dealloc
{
    [DataListWindowController releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)tableDoubleClick:(NSTableView*)tableView
{
    NSInteger row = [tableView selectedRow];
    
    self.currentlySelectedIdentifier = [allIdentifiers objectAtIndex:[[autocompletedIndices objectAtIndex:row] intValue]];
    self.currentIdentifier = self.currentlySelectedIdentifier;
    
    if (currentlySelectedIdentifier)
    {
        [listDelegate editDataWithIdentifier:currentlySelectedIdentifier];
    }
}

- (IBAction)updateDataList:(id)sender
{
    [listDelegate updateDataList];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [autocompletedIndices count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [allIdentifiers objectAtIndex:[[autocompletedIndices objectAtIndex:row] intValue]];
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    self.currentlySelectedIdentifier = [allIdentifiers objectAtIndex:[[autocompletedIndices objectAtIndex:row] intValue]];
    self.currentIdentifier = self.currentlySelectedIdentifier;
    [self.identifierTextField setStringValue:self.currentIdentifier];
    return YES;
}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return YES;
}

- (void)tableView:(NSTableView *)tableView
   setObjectValue:(id)object
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row;
{
    NSString* original = [self   tableView:tableView
                 objectValueForTableColumn:tableColumn
                                       row:row];
    
    [listDelegate renameDataWithIdentifier:original
                   newIdentifier:object];
}

- (void)controlTextDidChange:(NSNotification *)obj
{
    if ([obj.object isEqual:self.searchTextField])
    {
        self.currentSubstring = [obj.object stringValue];
        [self searchAutocompleteEntriesWithSubstring:self.currentSubstring];
    }
    
    if ([obj.object isEqual:self.identifierTextField])
    {
        self.currentIdentifier = [obj.object stringValue];
    }
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    [self.autocompletedIndices removeAllObjects];
    
    NSArray* source = self.allIdentifiers;
    
    NSMutableSet* results = [NSMutableSet new];
    for(int i = 0; i < [source count]; ++i)
    {
        [results addObject:[NSNumber numberWithInt:i]];
    }
    
    NSArray* substrings = [substring componentsSeparatedByString:@" "];
    NSMutableArray* tempResults = [NSMutableArray array];
    
    for(NSString* subst in substrings)
    {
        if ([subst isEqualToString:@""])
        {
            continue;
        }
        
        [tempResults removeAllObjects];
        for(int i = 0; i < source.count; ++i) {
            NSString* curString = [source objectAtIndex:i];
            NSRange substringRange = [curString rangeOfString:subst options:NSCaseInsensitiveSearch];
            if (substringRange.location != NSNotFound) {
                [tempResults addObject:[NSNumber numberWithInt:i]];  
            }
        }
        [results intersectSet:[NSSet setWithArray:tempResults]];
    }
    
    
    [self.autocompletedIndices addObjectsFromArray:[[results allObjects] sortedArrayUsingComparator:^NSComparisonResult(NSNumber* obj1, NSNumber* obj2) {
        return [[source objectAtIndex:obj1.intValue] localizedCaseInsensitiveCompare:[source objectAtIndex:obj2.intValue]];
    }]];
    
    [results release];    
    
    [dataListTable reloadData];
}

- (void)reloadData
{
    [self searchAutocompleteEntriesWithSubstring:self.currentSubstring];
}

- (IBAction)deleteSelectedData:(id)sender
{
    if (currentlySelectedIdentifier)
    {
        [listDelegate deleteDataWithIdentifier:currentlySelectedIdentifier];
        [self searchAutocompleteEntriesWithSubstring:self.currentSubstring];
    }
}

- (IBAction)duplicateSelectedData:(id)sender
{
    int duplicateVersion = 1;
    
    do
    {
        self.currentIdentifier = [self.currentlySelectedIdentifier stringByAppendingFormat:@" - DUPLICATE %d", duplicateVersion];
        duplicateVersion++;
    }
    while ([self.allIdentifiers containsObject:self.currentIdentifier]);
    
    [listDelegate duplicateDataWithIdentifier:self.currentlySelectedIdentifier newIdentifier:self.currentIdentifier];
    [self searchAutocompleteEntriesWithSubstring:self.currentSubstring];
    
    [listDelegate editDataWithIdentifier:self.currentIdentifier];
}

- (IBAction)createNewData:(id)sender
{
    [listDelegate newDataWithIdentifier:self.currentIdentifier];
    [self searchAutocompleteEntriesWithSubstring:self.currentSubstring];
    
    [listDelegate editDataWithIdentifier:self.currentIdentifier];
}

- (BOOL)windowShouldClose:(id)sender
{
    return NO;
}

@end
