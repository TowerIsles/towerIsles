#import "Service.h"

@implementation Service
@end

@implementation RequestAgent
@end

@implementation PendingRequestAgent

- (void)dealloc
{
    self.responseBlock = nil;
    [super dealloc];
}

- (void)performRequest
{
    
}

@end

@implementation StubbedRequestAgent

- (void)dealloc
{
    self.responseBlock = nil;
    self.stubbedOutputBlock = nil;
    self.stubbedOutputNoInputBlock = nil;
    [super dealloc];
}

- (void)performRequest
{
    [self performSelector:@selector(delayedPerformRequest)
               withObject:nil
               afterDelay:0.6];
}

- (void)delayedPerformRequest
{
    if (_commandInput != nil)
    {
        _responseBlock(_stubbedOutputBlock(_commandInput));
    }
    else
    {
        _responseBlock(_stubbedOutputNoInputBlock());
    }
}

@end
