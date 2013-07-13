
@interface Identifier : NSObject<NSCopying>

- (BOOL)isEqual:(Identifier*)identifier;

- (NSUInteger)hash;

- (NSString*)stringValue;

- (void)setStringIdentifier:(NSString*)stringIdentifier;

- (void)setIntIdentifier:(int64_t)intIdentifier;

+ (Identifier*)objectWithStringIdentifier:(NSString*)stringIdentifier;

+ (Identifier*)objectWithIntIdentifier:(int)intIdentifier;

+ (Identifier*)objectWithNextIdentifier;

@end
