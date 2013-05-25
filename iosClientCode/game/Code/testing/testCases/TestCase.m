#import "TestCase.h"

@interface TestCase : ManagedPropertiesObject
@property (nonatomic, copy) TestBlock testBlock;
@property (nonatomic, retain) NSString* testName;
@end

@implementation TestCase
@end

@interface TestSuite ()
@property (nonatomic, retain) NSMutableArray* testCases;
@end

@implementation TestSuite

- (id)init
{
    if (self = [super init])
    {
        _testCases = [NSMutableArray new];
    }
    return self;
}

- (void)setup {}

- (void)addTestCaseWithName:(NSString*)testName
                  testBlock:(TestBlock)testBlock
{
    TestCase* testCase = [TestCase object];
    testCase.testBlock = testBlock;
    testCase.testName = testName;
    [_testCases addObject:testCase];
}

- (void)run
{
    int successfulTestCount = 0;
        
    NSLog(@"Begin Suite ---------------- %s", class_getName(self.class));
    
    for (TestCase* testCase in _testCases)
    {
        if (testCase.testBlock())
        {
            successfulTestCount++;
        }
        else
        {
            NSLog(@"FAILED - %@", testCase.testName);
        }
    }
    
    NSLog(@"Summary -------------------- %d/%d passed", successfulTestCount, _testCases.count);
    NSLog(@"=============");
}

@end
