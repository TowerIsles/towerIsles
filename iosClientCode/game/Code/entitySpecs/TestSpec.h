#import "Game.h"

@class TestComponentOne;
@class TestComponentTwo;

EntitySpecInterface(TestSpec, EntitySpec)
{
    TestComponentTwo* testComponentTwo;
}
@end

EntitySpecInterface(TestSpecTwo, EntitySpec)
{
    TestComponentOne* testComponentOne;
}
@end
