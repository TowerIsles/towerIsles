#import "SerializationTesting.h"
#import "Game.h"

@implementation SerializationTesting

- (void)setup
{
    AddTestCase(@"Remove Default Values (1)", ^BOOL{
        NSMutableDictionary* dictionary = [NSMutableDictionary object];
        NSMutableDictionary* nestedEmptyDictionary = [NSMutableDictionary object];
        NSMutableDictionary* nestedDictionary = [NSMutableDictionary object];
        
        [dictionary setObject:[NSNull null]
                       forKey:@"NSNull.null"];
        
        [dictionary setObject:[NSObject object]
                       forKey:@"object"];

        [dictionary setObject:nestedDictionary
                       forKey:@"nestedDictionary"];
        
        [dictionary setObject:nestedEmptyDictionary
                       forKey:@"nestedEmptyDictionary"];
        
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
        
        [nestedEmptyDictionary setObject:[NSNull null]
                                  forKey:@"NSNull.null"];

        [nestedDictionary setObject:Float(-1)
                             forKey:@"floatOfNeg1"];
        
        [Util removeDefaultValuesFromDictionary:dictionary];
        
        //NSLog(@"dictionary = %@", dictionary);
        
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
        keyShouldExist(dictionary, @"nestedDictionary");

        keyShouldExist(nestedDictionary, @"floatOfNeg1");
        
        keyShouldNotExist(nestedDictionary, @"NSNull.null");
        keyShouldNotExist(dictionary, @"nestedEmptyDictionary");
        
        return YES;
    });
    
    AddTestCase(@"Identifier class as key", ^BOOL{
        NSMutableDictionary* theDictionary = [NSMutableDictionary object];
        Identifier* intKeyOne = [Identifier objectWithIntIdentifier:0];
        Identifier* intKeyTwo = [Identifier objectWithIntIdentifier:0];
        Identifier* stringKeyOne = [Identifier objectWithStringIdentifier:@"string"];
        Identifier* stringKeyTwo = [Identifier objectWithStringIdentifier:@"string"];
        
        [theDictionary setObject:[NSObject object]
                          forKey:intKeyOne];
        
        [theDictionary setObject:[NSObject object]
                          forKey:intKeyTwo];
        
        [theDictionary setObject:[NSObject object]
                          forKey:stringKeyOne];
        
        [theDictionary setObject:[NSObject object]
                          forKey:stringKeyTwo];
        
        if ([theDictionary objectForKey:intKeyOne] != [theDictionary objectForKey:intKeyTwo])
            return NO;
        
        if ([theDictionary objectForKey:stringKeyOne] != [theDictionary objectForKey:stringKeyTwo])
            return NO;
        
        return YES;
    });
    
    [self run];
}

@end