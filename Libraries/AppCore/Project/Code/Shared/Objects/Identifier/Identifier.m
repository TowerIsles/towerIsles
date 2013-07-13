#import "NSObject+Object.h"
#import "NSObject+Serialization.h"
#import "Identifier.h"
#import "AppCoreAsserts.h"
#import "AppCoreUtilities.h"

@interface Identifier ()
{
	
}

@property (nonatomic, retain) NSString* identifier;

@end


@implementation Identifier

Serialize(identifier);

- (void)dealloc
{
    [_identifier release];
    [super dealloc];
}

- (NSString*)description
{
    return _identifier;
}

- (BOOL)isEqual:(Identifier*)identifier
{
    return [_identifier isEqual:identifier.identifier];
}

- (NSUInteger)hash
{
    return [_identifier hash];
}

- (NSString*)stringValue
{
    return _identifier;
}

- (id)copyWithZone:(NSZone*)zone
{
    Identifier* identifer = [[Identifier object] retain];
    identifer.identifier = _identifier;
    return identifer;
}

- (void)setStringIdentifier:(NSString*)stringIdentifier
{
    CheckTrue(_identifier == nil);
    self.identifier = stringIdentifier;
}

- (void)setIntIdentifier:(int64_t)intIdentifier
{
    CheckTrue(_identifier == nil);
    self.identifier = Format(@"%lld", intIdentifier);
}

+ (Identifier*)objectWithStringIdentifier:(NSString*)stringIdentifier
{
    Identifier* identifier = [Identifier object];
    [identifier setStringIdentifier:stringIdentifier];
    return identifier;
}

+ (Identifier*)objectWithIntIdentifier:(int)intIdentifier
{
    Identifier* identifier = [Identifier object];
    [identifier setIntIdentifier:intIdentifier];
    return identifier;
}

+ (Identifier*)objectWithNextIdentifier
{
    static int nextGeneratedIdentifier = 1;
    return [Identifier objectWithStringIdentifier:Format(@"%d", nextGeneratedIdentifier++)];
}

@end
