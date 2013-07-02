#import "ModuleViewController.h"


@interface ModuleListViewController : ModuleViewController
@property (nonatomic, assign) BOOL collapseContentByDefault;

- (void)setupWithValueArray:(NSMutableArray*)valueArray
                typeStrings:(NSArray*)typeStringsOrNil
          defaultValueBlock:(id(^)(NSString* typeString))defaultValueBlock
        moduleForValueBlock:(ModuleViewController*(^)(id value))moduleForValueBlock
   displayNameForValueBlock:(NSString*(^)(id value))displayNameForValueBlock;

- (void)setupWithValueDictionary:(NSMutableDictionary*)valueDictionary
                     typeStrings:(NSArray*)typeStringsOrNil
               defaultValueBlock:(id(^)(NSString* typeString))defaultValueBlock
             moduleForValueBlock:(ModuleViewController*(^)(id value))moduleForValueBlock
        displayNameForValueBlock:(NSString*(^)(id value))displayNameForValueBlock;

@end


