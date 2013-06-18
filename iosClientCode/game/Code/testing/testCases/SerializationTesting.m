#import "SerializationTesting.h"
#import "Game.h"

@implementation SerializationTesting

- (void)setup
{
    AddTestCase(@"Remove Default Values (1)", ^BOOL{
        NSMutableDictionary* dictionary = [NSMutableDictionary object];
        NSMutableDictionary* nestedDictionary = [NSMutableDictionary object];
        
        [dictionary setObject:[NSNull null]
                       forKey:@"NSNull.null"];
        
        [dictionary setObject:[NSObject object]
                       forKey:@"object"];

        [dictionary setObject:nestedDictionary
                       forKey:@"nestedDictionary"];
        
        [dictionary setObject:Float(0)
                       forKey:@"floatOfZero"];

        [dictionary setObject:Float(0.0001f)
                       forKey:@"floatOf.0001f"];
        
        [dictionary setObject:Integer(0)
                       forKey:@"integerOfZero"];

        [dictionary setObject:Integer(1)
                       forKey:@"integerOfOne"];
        
        [dictionary setObject:Format(@"0")
                       forKey:@"stringZero"];

        [dictionary setObject:Format(@"0.0001")
                       forKey:@"string0.00001"];
        
        [dictionary setObject:Bool(false)
                       forKey:@"stringFalse"];

        [dictionary setObject:Bool(true)
                       forKey:@"stringTrue"];
        
        [nestedDictionary setObject:[NSNull null]
                             forKey:@"NSNull.null"];
        
        [Util removeDefaultValuesFromDictionary:dictionary];
        
        NSLog(@"dictionary = %@", dictionary);
        
#define keyShouldExist(dictionaryArg, keyArg) if ([dictionaryArg objectForKey:keyArg] == nil) return NO;
#define keyShouldNotExist(dictionaryArg, keyArg) if ([dictionaryArg objectForKey:keyArg] != nil) return NO;
        
        keyShouldNotExist(dictionary, @"NSNull.null");
        keyShouldNotExist(dictionary, @"floatOfZero");
        keyShouldNotExist(dictionary, @"integerOfZero");
        keyShouldNotExist(dictionary, @"stringFalse");
        keyShouldNotExist(dictionary, @"NSNull.null");
        
        keyShouldExist(dictionary, @"stringTrue");
        keyShouldExist(dictionary, @"string0.00001");
        keyShouldExist(dictionary, @"integerOfOne");
        keyShouldExist(dictionary, @"floatOf.0001f");
        keyShouldExist(dictionary, @"object");
        keyShouldExist(dictionary, @"stringTrue");
//        keyShouldExist(dictionary, @"nestedDictionary");
        
        keyShouldNotExist(nestedDictionary, @"NSNull.null");
        keyShouldNotExist(dictionary, @"nestedDictionary");
        
        return YES;
    });
    
    [self run];
}

@end