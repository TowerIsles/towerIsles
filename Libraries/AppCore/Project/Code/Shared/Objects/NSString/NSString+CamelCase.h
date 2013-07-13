#import "NSString+CamelCase.h"

@implementation NSString(CamelCase)

- (NSString*)stringByConvertingCamelCaseToCapitalizedWords
{
	NSMutableString* ret = [NSMutableString string];
	
	BOOL lastCharacterWasLowerCase = NO;
	BOOL pendingInitialism = NO;
        
    NSUInteger currentCharIndex = 0;
    unichar currentChar = [self characterAtIndex:currentCharIndex];
    
    if (currentChar == 'm')
    {
        currentCharIndex++;
        currentChar = [self characterAtIndex:currentCharIndex];
        
        if (currentChar == '_')
        {
            // underscore
            currentCharIndex = 2;
        }
        else if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[self characterAtIndex:currentCharIndex]])
        {
            currentCharIndex = 1;
        }
        else
        {
            currentCharIndex = 0;
        }
    }
    
	for (NSUInteger i = currentCharIndex; i < [self length]; ++i)
	{
		unichar oneChar = [self characterAtIndex:i];
		
		if ([[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:oneChar])
		{
			if (i == 0)
			{
				[ret appendFormat:@"%@", [[NSString stringWithCharacters:&oneChar
																  length:1] capitalizedString]];
			}
			else
			{
				[ret appendFormat:@"%C", oneChar];
			}
			
			lastCharacterWasLowerCase = YES;
		}
		else if ([[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:oneChar])
		{
			if (lastCharacterWasLowerCase)
			{
				[ret appendFormat:@" %C", oneChar];
			}
			else if (pendingInitialism)
			{
				if (i + 1 < [self length] &&
					![[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[self characterAtIndex:i + 1]])
				{
					pendingInitialism = NO;
					[ret appendFormat:@" %C", oneChar];
				}
				else
				{
					[ret appendFormat:@"%C", oneChar];
				}
			}
			else
			{
				[ret appendFormat:@"%C", oneChar];
				pendingInitialism = YES;
			}
		}
		else
		{
			lastCharacterWasLowerCase = NO;
			[ret appendFormat:@"%C", oneChar];
		}
	}
	return ret;
}
@end