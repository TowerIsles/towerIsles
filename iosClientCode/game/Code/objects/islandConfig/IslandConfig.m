#import "IslandConfig.h"
#import "LandData.h"

@implementation IslandConfigEntity
@end

@interface IslandConfigEntry : ManagedPropertiesObject
@property (nonatomic, retain) NSArray* islandConfigEntities;
@end



@implementation IslandConfigEntry

+ (void)setupSerialization
{
    [self registerClass:IslandConfigEntity.class
           forContainer:@"islandConfigEntities"];
}

@end



@interface IslandConfigGroup : ManagedPropertiesObject
@property (nonatomic, retain) NSArray* islandConfigEntries;
@property (nonatomic, assign) int choiceCount;
@property (nonatomic, assign) BOOL exclusiveChoices;
@end

@implementation IslandConfigGroup

+ (void)setupSerialization
{
    [self registerClass:IslandConfigEntry.class
           forContainer:@"islandConfigEntries"];
}

@end



@interface IslandConfig ()
@property (nonatomic, retain) NSArray* islandConfigGroups;
@end

@implementation IslandConfig

+ (void)setupSerialization
{
    [self registerClass:IslandConfigGroup.class
           forContainer:@"islandConfigGroups"];
}

- (IslandData*)generateIslandData;
{
    NSMutableArray* possibleEntries = [NSMutableArray object];
    
    NSMutableArray* islandConfigEntities = [NSMutableArray object];
    
    for (IslandConfigGroup* group in _islandConfigGroups)
    {
        if (group.exclusiveChoices)
        {
            [possibleEntries removeAllObjects];
            
            for (IslandConfigEntry* entry in group.islandConfigEntries)
            {
                [possibleEntries addObject:entry];
            }
            
            CheckTrue(possibleEntries.count >= group.choiceCount);
            
            for (int i = 0; i < group.choiceCount; ++i)
            {
                int selectedIndex = [Util randomIntBetweenMin:0
                                                          max:possibleEntries.count - 1];
                
                IslandConfigEntry* chosenEntry = [possibleEntries objectAtIndex:selectedIndex];
                
                for (IslandConfigEntity* entity in chosenEntry.islandConfigEntities)
                {
                    [islandConfigEntities addObject:entity];
                }
                
                [possibleEntries removeObjectAtIndex:selectedIndex];
            }
        }
        else
        {
            int selectedIndex = [Util randomIntBetweenMin:0
                                                      max:group.islandConfigEntries.count - 1];
            
            IslandConfigEntry* chosenEntry = [group.islandConfigEntries objectAtIndex:selectedIndex];
            
            for (IslandConfigEntity* entity in chosenEntry.islandConfigEntities)
            {
                [islandConfigEntities addObject:entity];
            }
        }
    }
    
    IslandData* islandData = [IslandData object];
    
    return islandData;
}

@end
