#import "ViewLayer.h"
#import "ManagedView.h"
#import "AppDirector.h"
#import "AppCoreAsserts.h"

@interface ViewLayer ()
{
	AppDirector* director;
}

@property (nonatomic, retain) NSMutableArray* currentManagedViews;

@end


@implementation ViewLayer

- (id)init
{
    if (self = [super init])
    {
        _currentManagedViews = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [ViewLayer releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)showManagedView:(ManagedView*)managedView
             setupBlock:(void(^)(ManagedView*))setupBlock
{
    CheckNotNull(managedView);
    
    [managedView setViewLayer:self];
    
    _view.hidden = NO;
    
    _view.userInteractionEnabled = YES;
    
    [_view addSubview:managedView.managedUIView];
    
    [_currentManagedViews addObject:managedView];
    
    managedView.managedUIView.hidden = NO;
    
    managedView.managedUIView.userInteractionEnabled = YES;
    
    [managedView sizeToScreen];
    
    if (setupBlock && managedView)
    {
        setupBlock(managedView);
    }
    
    [managedView viewWillShow];
    
    [managedView fadeIn];
}

- (void)dismissManagedView:(ManagedView*)managedView
{
    CheckNotNull(managedView);
    
    CheckTrue([_currentManagedViews containsObject:managedView]);
    
    [managedView fadeOut];
    
    [_currentManagedViews removeObject:managedView];
}

- (void)dismissAllViews
{
    NSArray* viewsToRemove = [_currentManagedViews copy];
    for (ManagedView* managedView in viewsToRemove)
    {
        [managedView dismiss];
    }
    [viewsToRemove release];
}

@end
