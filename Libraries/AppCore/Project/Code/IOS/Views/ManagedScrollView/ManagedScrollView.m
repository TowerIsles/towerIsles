#import "ManagedScrollView.h"
#import "NSObject+Object.h"

typedef enum
{
    ScrollDirection_horizontal,
    ScrollDirection_vertical
}  ScrollDirection;

@interface ManagedScrollView ()
@property (nonatomic, retain) NSMutableArray* scrollViewItems;
@property (nonatomic, assign) int currentContentWidth;
@property (nonatomic, assign) int currentContentHeight;
@property (nonatomic, assign) int currentHorizontalSpacing;
@property (nonatomic, assign) int currentVerticalSpacing;
@property (nonatomic, assign) ScrollDirection scrollDirection;
@end

@implementation ManagedScrollView

- (void)dealloc
{
    [self removeAllManagedViews];
    [_scrollViewItems release];
    [super dealloc];
}

- (void)awakeFromNib
{
    self.scrollDirection = ScrollDirection_vertical;
    self.scrollViewItems = [NSMutableArray object];
    self.tag = 0;
}

- (NSArray*)managedViews
{
    return _scrollViewItems;
}

- (void)addManagedView:(ManagedView*)managedView
  refreshViewPlacement:(BOOL)refreshViewPlacement
{
    [self addManagedView:managedView
                 atIndex:_scrollViewItems.count
    refreshViewPlacement:refreshViewPlacement];
}

- (void)addManagedView:(ManagedView*)managedView
               atIndex:(int)index
  refreshViewPlacement:(BOOL)refreshViewPlacement
{
    [self internal_addView:managedView
                   atIndex:index];
    if (refreshViewPlacement)
    {
        [self internal_refreshViewPlacement];
    }
}

- (void)addManagedViews:(NSArray*)managedViews
{
    for (ManagedView* managedView in managedViews)
    {
        [self internal_addView:managedView
                       atIndex:_scrollViewItems.count];
    }
    [self internal_refreshViewPlacement];
}

- (void)removeAllManagedViews
{
    NSArray* scrollViewItems = [[_scrollViewItems copy] autorelease];
    for (ManagedView* managedView in scrollViewItems)
    {
        [managedView dismiss];
    }
}

- (void)setShouldScrollVertical:(BOOL)shouldScrollVertical
{
    _scrollDirection = shouldScrollVertical ? ScrollDirection_vertical : ScrollDirection_horizontal;
    [self internal_refreshViewPlacement];
}

- (void)setHorizontalSpacing:(int)horizontalSpacing
{
    _currentHorizontalSpacing = horizontalSpacing;
    [self internal_refreshViewPlacement];
}

- (void)setVerticalSpacing:(int)verticalSpacing
{
    _currentVerticalSpacing = verticalSpacing;
    [self internal_refreshViewPlacement];
}

- (void)internal_addView:(ManagedView*)managedView
                 atIndex:(int)index
{
	[managedView viewWillShow];
    
    [self addSubview:managedView.managedUIView];
	
    [_scrollViewItems insertObject:managedView
                           atIndex:index];
}

- (void)internal_placeManagedView:(ManagedView*)managedView
                         forIndex:(int)viewIndex
                      ofTotalView:(int)viewCount
{
    UIView* managedUIView = managedView.managedUIView;
    
	int width = managedUIView.frame.size.width;
	int height = managedUIView.frame.size.height;
    
    if (_scrollDirection == ScrollDirection_horizontal)
    {
        _currentContentHeight = height;
        if (viewIndex > 0)
        {
            _currentContentWidth += _currentHorizontalSpacing;
        }
        
		[managedUIView setFrame:CGRectMake(_currentContentWidth, 0, width, height)];
		
        _currentContentWidth += width;
    }
    else if (_scrollDirection == ScrollDirection_vertical)
    {
        _currentContentWidth = width;
		[managedUIView setFrame:CGRectMake(0, _currentContentHeight, width, height)];
		_currentContentHeight += (height + _currentVerticalSpacing);
	}
}

- (void)internal_refreshViewPlacement
{
    _currentContentWidth = 0;
    _currentContentHeight = 0;
    
    int index = 0;
    
    for (ManagedView* scrollViewItem in _scrollViewItems)
    {
        [self internal_placeManagedView:scrollViewItem
                               forIndex:index
                            ofTotalView:_scrollViewItems.count];

        scrollViewItem.managedUIView.tag = index++;
        self.hidden = NO;
        self.userInteractionEnabled = YES;
        scrollViewItem.managedUIView.hidden = NO;
        scrollViewItem.managedUIView.userInteractionEnabled = YES;
    }
        
    self.contentSize = CGSizeMake(_currentContentWidth, _currentContentHeight);
}

- (void)refreshViewPlacement
{
    [self internal_refreshViewPlacement];
}

// TODO - recalculate this so that it is accurate.
// the current implementation is one off, it ignore the content height of the first view - shit thats a lie. FUCK beats me, have fun

- (int)contentWidth
{
    int accumulatedWidth = 0;
    for (ManagedView* scrollViewItem in _scrollViewItems)
    {
        if (_scrollDirection == ScrollDirection_horizontal)
        {
            accumulatedWidth += scrollViewItem.managedUIView.frame.size.width;
            if ([_scrollViewItems indexOfObject:scrollViewItem] != 0)
                accumulatedWidth += _currentHorizontalSpacing;
        }
        else if (_scrollDirection == ScrollDirection_vertical)
        {
            return scrollViewItem.managedUIView.frame.size.height;
        }
    }
    return accumulatedWidth;
}

- (int)contentheight
{
    int accumulatedHeight = 0;
    for (ManagedView* scrollViewItem in _scrollViewItems)
    {
        if (_scrollDirection == ScrollDirection_horizontal)
        {
            return scrollViewItem.managedUIView.frame.size.width;
        }
        else if (_scrollDirection == ScrollDirection_vertical)
        {
            accumulatedHeight += scrollViewItem.managedUIView.frame.size.height;
            if ([_scrollViewItems indexOfObject:scrollViewItem] != 0)
                accumulatedHeight += _currentVerticalSpacing;
        }
    }
    return accumulatedHeight;
}

@end

@implementation ManagedPassthroughScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (UIView*)hitTest:(CGPoint)point
         withEvent:(UIEvent*)event
{
	UIView* hit = [super hitTest:point
                       withEvent:event];
	
    return hit == self ? nil : hit;
}

@end