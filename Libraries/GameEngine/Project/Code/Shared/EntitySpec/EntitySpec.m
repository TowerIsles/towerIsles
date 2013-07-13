#import "EntitySpec.h"
#import "EntityComponent.h"
#import "Entity.h"
#import "EntityManager.h"
#import "AppCoreAsserts.h"
#import "GameEngineUtilities.h"

#define keyFromIvar(ivarArg) Format(@"%s", ivar_getTypeEncoding(ivarArg))

@interface EntitySpec ()
{
    EntityManager* entityManager;
}

@property (nonatomic, retain) Entity* entity;
@end

@implementation EntitySpec

NSMutableDictionary* injectableComponentClassesByIvar = nil;
NSMutableDictionary* injectableSpecClassesByIvar = nil;

+ (void)initialize
{
    if (injectableComponentClassesByIvar == nil)
    {
        injectableComponentClassesByIvar = [NSMutableDictionary new];
    }
    if (injectableSpecClassesByIvar == nil)
    {
        injectableSpecClassesByIvar = [NSMutableDictionary new];
    }
    
	if (self != kEntitySpecClass)
	{
		unsigned int ivarCount;
		Ivar* ivars = class_copyIvarList(self, &ivarCount);
		
		for (unsigned int ivarIndex = 0; ivarIndex < ivarCount; ivarIndex++)
		{
			Ivar ivar = ivars[ivarIndex];

			Class potentialClass = [NSObject classForIvar:ivar];
			
			if ([potentialClass isSubclassOfClass:kEntityComponentClass])
			{
				[injectableComponentClassesByIvar setObject:potentialClass
                                                     forKey:keyFromIvar(ivar)];
			}
			else if ([potentialClass isSubclassOfClass:kEntitySpecClass])
			{
				[injectableSpecClassesByIvar setObject:potentialClass
                                                forKey:keyFromIvar(ivar)];
			}
		}
		
		free(ivars);
	}
}

+ (BOOL)internal_verifyIvarsMatchRecursive:(Entity*)entity
                              currentClass:(Class)currentClass
{
    if (currentClass == kEntitySpecClass)
        return YES;
    
    unsigned int ivarCount;
    Ivar* ivars = class_copyIvarList(currentClass, &ivarCount);
    
    for (unsigned int i = 0; i < ivarCount; ++i)
    {
        Ivar ivar = ivars[i];
        
        Class componentClass = injectableComponentClassesByIvar[keyFromIvar(ivar)];
        
        if (componentClass != nil)
        {
            if ([entity componentForClass:componentClass] == nil)
            {
                free(ivars);
                return NO;
            }
            
            continue;
        }
    }
    
    free(ivars);
    return [EntitySpec internal_verifyIvarsMatchRecursive:entity
                                             currentClass:class_getSuperclass(currentClass)];
}

+ (BOOL)doesEntityConformToSpecClass:(Entity*)entity
{
    return [EntitySpec internal_verifyIvarsMatchRecursive:entity
                                             currentClass:self];
}

- (Identifier*)entityIdentifier
{
    return _entity.entityIdentifier;
}

- (NSString*)description
{
    return _entity.description;
}

- (void)internal_injectIvarsRecursive:(Class)currentClass
{
    if (currentClass == kEntitySpecClass)
        return;
    
    unsigned int ivarCount;
    Ivar* ivars = class_copyIvarList(currentClass, &ivarCount);
    
    for (unsigned int i = 0; i < ivarCount; ++i)
    {
        Ivar ivar = ivars[i];
        
        Class componentClass = [injectableComponentClassesByIvar objectForKey:keyFromIvar(ivar)];
        
        if (componentClass != nil)
        {
            EntityComponent* component = [_entity componentForClass:componentClass];
            
            CheckTrue(component != nil);
            
            object_setIvar(self, ivar, component);
            
            continue;
        }
        
        Class specClass = [injectableSpecClassesByIvar objectForKey:keyFromIvar(ivar)];
        
        if (specClass != nil)
        {
            EntitySpec* entitySpec = [_entity entitySpecForClass:specClass];
            
            CheckTrue(entitySpec != nil);
            
            object_setIvar(self, ivar, entitySpec);
        }
    }
    
    free(ivars);
    
    [self internal_injectIvarsRecursive:class_getSuperclass(currentClass)];
}

- (void)injectFromEntity:(Entity*)entity
{
    self.entity = entity;
    
    [self internal_injectIvarsRecursive:self.class];
}

- (BOOL)isSpecOfSpec:(EntitySpec*)entitySpec
{
    return _entity == entitySpec.entity;
}

- (BOOL)isValid
{
    return _entity != nil &&
           !self.isQueuedForDestruction;
}

- (BOOL)isQueuedForDestruction
{
    return _entity.queuedForDestruction;
}

- (void)queueDestruction
{
    if (!self.isQueuedForDestruction)
    {
        _entity.queuedForDestruction = YES;
        [entityManager queueEntityForRemoval:_entity];
    }
}

- (id)transformedSpec:(Class)entitySpecClass
{
    CheckTrue([_entity entitySpecForClass:entitySpecClass] != nil);
    return [_entity entitySpecForClass:entitySpecClass];
}

- (id)possiblyTransformedSpec:(Class)entitySpecClass
{
    return [_entity entitySpecForClass:entitySpecClass];    
}

- (void)load {}

- (void)teardown
{
    self.entity = nil;
}

@end
