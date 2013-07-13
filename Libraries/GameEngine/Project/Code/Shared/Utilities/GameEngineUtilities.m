#import "GameEngineUtilities.h"
#import "EntityComponent.h"
#import "EntitySpec.h"

Class kEntitySpecClass = nil;
Class kEntityComponentClass = nil;

@implementation Utilities (GameEngine)

+ (void)initializeGameEngineClasses
{
    [Utilities initializeGraphicsEngineClasses];
    
    kEntityComponentClass = EntityComponent.class;
    kEntitySpecClass = EntitySpec.class;
}

@end
