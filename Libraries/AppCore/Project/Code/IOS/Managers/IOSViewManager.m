#import "ViewManager.h"
#import "ManagedView.h"
#import "AppDirector.h"
#import "ViewLayer.h"
#import "AppCoreAsserts.h"
#import "ViewDirector.h"

@interface ViewManager ()
{
}
@property (nonatomic, retain) NSMutableDictionary* layers;
@property (nonatomic, retain) ViewDirector* activeViewDirector;
@end

@implementation ViewManager

- (id)init
{
    if (self = [super init])
    {
        _layers = [NSMutableDictionary new];
    }
    return self;
}

- (void)load
{
}

- (void)reload
{
    for (ViewLayer* viewLayer in _layers.allValues)
    {
        [viewLayer dismissAllViews];
    }
}

- (void)setViewDirector:(ViewDirector*)viewDirector
{
    CheckTrue(_activeViewDirector == nil);
    self.activeViewDirector = viewDirector;
}

- (void)setDefaultViewLayer:(ViewLayer*)viewLayer
{
    [self setViewLayer:viewLayer
             layerName:@"default"];
}

- (void)setViewLayer:(ViewLayer*)viewLayer
           layerName:(NSString*)layerName
{
    CheckTrue(_layers != nil);
    CheckTrue(_layers[layerName] == nil);

    [_layers setObject:viewLayer
                forKey:layerName];
}

- (void)showManagedViewOfClassOnDefaultLayer:(Class)managedViewClass
                                  setupBlock:(void(^)(id))setupBlock
{
    [self showManagedViewOfClassOnLayer:managedViewClass
                              layerName:@"default"
                             setupBlock:setupBlock];
}

- (void)showManagedViewOfClassOnLayer:(Class)managedViewClass
                            layerName:(NSString*)layerName
                           setupBlock:(void(^)(id))setupBlock
{
    CheckNotNull([_layers objectForKey:layerName]);
    
    ViewLayer* viewLayer = [_layers objectForKey:layerName];
    
    ManagedView* managedView = [self createManagedViewOfClass:managedViewClass
                                                       parent:viewLayer];
    
    [viewLayer showManagedView:managedView
                    setupBlock:setupBlock];
}

- (id)createManagedViewOfClass:(Class)managedViewClass
                        parent:(id)parent
{
    CheckNotNull(managedViewClass);
    
    CheckTrue([managedViewClass isSubclassOfClass:kManagedViewClass]);
    
    ManagedView* managedView = [ManagedView createManagedViewWithClass:managedViewClass
                                                                parent:parent];
    
    [self.director injectManagersIntoIVars:managedView];
    
    managedView.director = self.director;
    
    return managedView;
}

- (void)dismissAllViewsOnDefaultLayer
{
    ViewLayer* defaultViewLayer = _layers[@"default"];
    
    [defaultViewLayer dismissAllViews];
}

- (void)initOpenGLContext
{
    [_activeViewDirector initOpenGLContext];
}

@end
