#import "Game.h"

typedef BOOL(^TestBlock)(void);

#define AddTestCase(testNameArg, testBlockArg)                  \
{                                                               \
    [self addTestCaseWithName:testNameArg                       \
                    testBlock:testBlockArg];                    \
}

#define RunTestSuite(testSuiteClassName)                        \
{                                                               \
    testSuiteClassName* suite = [testSuiteClassName object];    \
    [suite setup];                                              \
}

#if ASSERT_IN_TESTS
#define TestCheckTrue(expression) CheckTrue((expression))
#else
#define TestCheckTrue(expression)                               \
{                                                               \
    if (!(expression))                                          \
        return NO;                                              \
}
#endif



@interface TestSuite : ManagedPropertiesObject

- (void)setup;

- (void)addTestCaseWithName:(NSString*)testName
                  testBlock:(TestBlock)testBlock;

- (void)run;

@end
