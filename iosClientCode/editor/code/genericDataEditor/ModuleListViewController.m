#import "ModuleListViewController.h"
#import "CollapsibleModuleViewController.h"
#import "Utilities.h"
#import "Asserts.h"
#import "DataEditor.h"

@interface ModuleListViewController () <CollapsibleContentOwner>
@property (nonatomic, retain) IBOutlet NSButton* addButton;
@property (nonatomic, retain) IBOutlet NSComboBox* addComboBox;
@property (nonatomic, retain) IBOutlet NSTextField* addLabel;
@property (nonatomic, retain) IBOutlet NSTextField* longTextLabel;

@property (nonatomic, copy) ModuleViewController*(^moduleForValueBlock)(id value);
@property (nonatomic, copy) NSString*(^displayNameForValueBlock)(id value);
@property (nonatomic, copy) id(^defaultValueBlock)(NSString* typeString);
@property (nonatomic, retain) NSArray* typeStrings;
@property (nonatomic, retain) NSMutableArray* valueArray;
@property (nonatomic, copy) VoidBlock commitIntermediateValuesBlock_internal;
@end

@interface DictionaryListItemWrapper : ManagedPropertiesObject
@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) id value;
@end

@implementation DictionaryListItemWrapper
@end


@interface NSObject (DataEditorWrapper)
- (id)wrappedValue;
- (id)unwrappedValue;
@end

@implementation NSObject (DataEditorWrapper)

- (id)wrappedValue
{
    return self;
}

- (id)unwrappedValue
{
    return self;
}

@end


@implementation ModuleListViewController

+ (NSString*)nibName
{
    return @"ModuleListView";
}

- (void)dealloc
{
    [ModuleListViewController releaseRetainedPropertiesOfObject:self];
    
    [super dealloc];
}

- (void)setupWithValueArray:(NSMutableArray*)valueArray
                typeStrings:(NSArray*)typeStringsOrNil
          defaultValueBlock:(id(^)(NSString* typeString))defaultValueBlock
        moduleForValueBlock:(ModuleViewController*(^)(id value))moduleForValueBlock
   displayNameForValueBlock:(NSString*(^)(id value))displayNameForValueBlock
{
    if (valueArray == nil)
    {
        [_addLabel setFrameWidth:500];
        [_addLabel setStringValue:@"NIL! (ask a dev to allocate this object manually in json)"];
        [_addComboBox removeFromSuperview];
        [_addButton removeFromSuperview];
        
        return;
    }
    
    for (int index = 0; index < valueArray.count; index++)
    {
        id value = [valueArray objectAtIndex:index];
        
        [valueArray replaceObjectAtIndex:index
                              withObject:[value wrappedValue]];
    }
    
    if (typeStringsOrNil == nil)
    {
        [_addLabel removeFromSuperview];
        [_addComboBox removeFromSuperview];
    }
    else
    {
        [_addButton removeFromSuperview];
    }
    
    self.defaultValueBlock = defaultValueBlock;
    self.valueArray = valueArray;
    self.typeStrings = typeStringsOrNil;
    self.moduleForValueBlock = moduleForValueBlock;
    self.displayNameForValueBlock = displayNameForValueBlock;
    
    self.commitIntermediateValuesBlock_internal = ^
    {
        for (int index = 0; index < valueArray.count; index++)
        {
            id value = [valueArray objectAtIndex:index];
            
            [valueArray replaceObjectAtIndex:index
                                  withObject:value];
        }
    };
    
    for (id value in valueArray)
    {
        CollapsibleModuleViewController* controller = [self addViewForValue:[value wrappedValue]];
        
        if (_collapseContentByDefault)
            [controller collapse];
    }
}

- (void)setupWithValueDictionary:(NSMutableDictionary*)valueDictionary
                     typeStrings:(NSArray*)typeStringsOrNil
               defaultValueBlock:(id(^)(NSString* typeString))defaultValueBlock
             moduleForValueBlock:(ModuleViewController*(^)(id value))moduleForValueBlock
        displayNameForValueBlock:(NSString*(^)(id value))displayNameForValueBlock
{
    if (valueDictionary == nil)
    {
        [_addLabel setFrameWidth:500];
        [_addLabel setStringValue:@"NIL! (ask a dev to allocate this object manually in json)"];
        
        [_addComboBox removeFromSuperview];
        [_addButton removeFromSuperview];
        
        return;
    }
    
    NSMutableArray* wrappers = [NSMutableArray object];
    
    for (NSString* key in [valueDictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }])
    {
        DictionaryListItemWrapper* wrapper = [DictionaryListItemWrapper object];
        wrapper.key = key;
        wrapper.value = [[valueDictionary objectForKey:key] wrappedValue];
        [wrappers addObject:wrapper];
    }
    
    [self setupWithValueArray:wrappers
                  typeStrings:typeStringsOrNil
            defaultValueBlock:^id(NSString *typeString) {
                DictionaryListItemWrapper* wrapper = [DictionaryListItemWrapper object];
                wrapper.key = typeString;
                CheckNotNull(wrapper.key)
                wrapper.value = [defaultValueBlock(typeString) wrappedValue];
                return wrapper;
            }
          moduleForValueBlock:^ModuleViewController *(DictionaryListItemWrapper* value) {
              return moduleForValueBlock([value.value wrappedValue]);
          }
     displayNameForValueBlock:^NSString *(DictionaryListItemWrapper* value) {
         if (displayNameForValueBlock == nil)
         {
             NSString* title = value.key;
             CheckNotNull(title)
             return title;
         }
         else
         {
             NSString* title = displayNameForValueBlock([value.value unwrappedValue]);
             CheckNotNull(title)
             return title;
         }
     }];
    
    VoidBlock commitIntermediateValuesBlock_internal_original = self.commitIntermediateValuesBlock_internal;
    
    self.commitIntermediateValuesBlock_internal = ^
    {
        if (commitIntermediateValuesBlock_internal_original != nil)
            commitIntermediateValuesBlock_internal_original();
        
        [valueDictionary removeAllObjects];
        
        for (DictionaryListItemWrapper* wrapper in wrappers)
        {
            [valueDictionary setObject:wrapper.value
                                forKey:wrapper.key];
        }
    };
}

- (void)teardown
{
    [super teardown];
    self.commitIntermediateValuesBlock_internal = nil;
}

- (void)notifyShouldCommitIntermediateValues
{
    if (_commitIntermediateValuesBlock_internal != nil)
        _commitIntermediateValuesBlock_internal();
    
    [super notifyShouldCommitIntermediateValues];
}

- (CollapsibleModuleViewController*)addViewForValue:(id)value
{
    ModuleViewController* controller = _moduleForValueBlock([value wrappedValue]);
    controller.owner = self;
    
    return [CollapsibleModuleViewController makeModuleCollapsible:controller
                                                    andAddToOwner:self
                                                        withTitle:_displayNameForValueBlock([value unwrappedValue])];
    
}

- (void)collapsibleContentWillBeRemovedAtIndex:(int)index
{
    [self.valueArray removeObjectAtIndex:index];
}

- (void)collapsibleContentWillMoveUpFromIndex:(int)index
{
    [self.valueArray exchangeObjectAtIndex:index
                         withObjectAtIndex:index-1];
}

- (void)collapsibleContentWillMoveDownFromIndex:(int)index
{
    [self.valueArray exchangeObjectAtIndex:index
                         withObjectAtIndex:index+1];
}

- (IBAction)addValue:(id)sender
{
    id value = ^
    {
        if ([sender isKindOfClass:[NSComboBox class]])
            return _defaultValueBlock([sender stringValue]);
        else
            return _defaultValueBlock(nil);
    }();
    
    if (value != nil)
    {
        [self.valueArray addObject:[value wrappedValue]];
        
        [self addViewForValue:value];
    }
}

@end
