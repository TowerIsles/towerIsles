#import "AppDirector.h"
#import "Manager.h"
#import "DisplayLink.h"
#import "PerformBlockAfterDelay.h"
#import <QuartzCore/QuartzCore.h>

@interface AppDirector ()
{
    DisplayLink* displayLink;
}

@property (nonatomic, retain) NSMutableArray* preUpdateBlocks;
@property (nonatomic, retain) NSMutableArray* updateBlocksAtInterval;
@property (nonatomic, retain) NSMutableArray* interUpdateBlocks;
@property (nonatomic, retain) NSMutableArray* postUpdateBlocks;
@property (nonatomic, retain) NSDictionary* managersByClass;
@property (nonatomic, assign) BOOL shouldReload;

@end

@implementation AppDirector

- (id)init
{
    if (self = [super init])
    {
        _preUpdateBlocks = [NSMutableArray new];
        _interUpdateBlocks = [NSMutableArray new];
        _updateBlocksAtInterval = [NSMutableArray new];
        _postUpdateBlocks = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [AppDirector releaseRetainedPropertiesOfObject:self];
    [super dealloc];
}

- (void)configure
{
    [self internal_setupManagers];
    
    [self injectManagersIntoIVars:self];
}

- (void)stopRunning
{
    if (displayLink)
    {
        [displayLink invalidate];
        displayLink = nil;
    }
}

- (void)beginRunning
{
    NSArray* managersSortedForLoad = [_managersByClass.allValues sortedArrayUsingComparator:^NSComparisonResult(Manager* managerA, Manager* managerB) {
        return [managerA loadPriority] < [managerB loadPriority];
    }];
    
    for (Manager* manager in managersSortedForLoad)
    {
        [manager load];
    }
    
    [self internal_performNextFrame];
    
    if (displayLink == nil)
    {
        displayLink = [DisplayLink objectWithOwner:self
                                    updateSelector:@selector(internal_performNextFrame)
                                     frameInterval:1]; // 60fps
    }
}

- (void)internal_performNextFrame
{
    if (_shouldReload)
    {
        incrementDelayedBlockContext();
        
        for (Manager* manager in _managersByClass.allValues)
        {
            [manager reload];
        }
        
        self.shouldReload = NO;
    }
    
    for (VoidBlock preUpdateBlock in _preUpdateBlocks)
    {
        preUpdateBlock();
    }
    
    NSTimeInterval frameStartTime = CACurrentMediaTime();
    
    for (UpdateBlockAtInterval* updateBlockAtInterval in _updateBlocksAtInterval)
    {
        [updateBlockAtInterval updateAtCurrentTimeInSec:frameStartTime];
        
        for (VoidBlock interUpdateBlock in _interUpdateBlocks)
        {
            interUpdateBlock();
        }
    }
    
    for (VoidBlock postUpdateBlock in _postUpdateBlocks)
    {
        postUpdateBlock();
    }
}

- (void)reload
{
    _shouldReload = YES;
}

- (void)registerPreUpdateBlock:(VoidBlock)preUpdateBlock
{
    [_preUpdateBlocks addObject:[[preUpdateBlock copy] autorelease]];
}

- (void)registerInterUpdateBlock:(VoidBlock)interUpdateBlock
{
    [_interUpdateBlocks addObject:[[interUpdateBlock copy] autorelease]];
}

- (void)registerPostUpdateBlock:(VoidBlock)postUpdateBlock
{
    [_postUpdateBlocks addObject:[[postUpdateBlock copy] autorelease]];
}

- (void)registerUpdateBlock:(VoidBlock)updateBlock
{
    [self registerUpdateBlockAtFPS:60
                       updateBlock:updateBlock];
}

- (void)registerUpdateBlockAtFPS:(int)updatesPerSecond
                     updateBlock:(VoidBlock)updateBlock
{
    [_updateBlocksAtInterval addObject:[UpdateBlockAtInterval objectWithUpdateBlock:updateBlock
                                                                   updatesPerSecond:updatesPerSecond
                                                                   currentTimeInSec:CACurrentMediaTime()]];
}


- (void)internal_setupManagers
{
    NSArray* managerClasses = [Utilities allClassesWithSuperClass:kManagerClass];
    
    NSMutableDictionary* managersByClass = [NSMutableDictionary object];
    
    for (Class managerClass in managerClasses)
    {
        Manager* manager = [managerClass object];
        
        manager.director = self;
        
        [managersByClass setObject:manager
                            forKey:(id<NSCopying>)[manager class]];
    }
    
    self.managersByClass = managersByClass;
    
	for (Manager* manager in _managersByClass.allValues)
    {
		[self injectManagersIntoIVars:manager];
    }
}

- (void)internal_removeManagers
{
    self.managersByClass = nil;
}

- (void)injectManagersIntoIVars:(id)injectee
{
    Class injecteeClass = [injectee class];
    while (injecteeClass &&
           injecteeClass != kObjectClass)
    {
        unsigned int ivarListCount = 0;
        Ivar* ivarList = class_copyIvarList(injecteeClass, &ivarListCount);
		
        for (int i = 0; i < ivarListCount; i++)
        {
			Class ivarClass = [NSObject classForIvar:ivarList[i]];
            
			if (ivarClass != nil)
			{
				id registeredManager = [_managersByClass objectForKey:ivarClass];
				
				if (registeredManager != nil)
				{
					object_setIvar(injectee, ivarList[i], registeredManager);
				}
			}
        }
        
        free(ivarList);
        injecteeClass = [injecteeClass superclass];
    }
}

- (id)managerForClass:(Class)managerClass
{
    return _managersByClass[managerClass];
}

@end
