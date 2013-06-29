#import "IslandIndex.h"


@interface IslandIndex ()
{

}
@property (nonatomic, assign) int xCoordinate;
@property (nonatomic, assign) int yCoordinate;
@end


@implementation IslandIndex

+ (IslandIndex*)objectWithX:(int)x
                          y:(int)y
{
    IslandIndex* islandIndex = [IslandIndex object];
    islandIndex.xCoordinate = x;
    islandIndex.yCoordinate = y;
    return islandIndex;
}

- (NSString*)description
{
    return [self formattedDictionaryKey];
}

- (NSString*)formattedDictionaryKey
{
    return Format(@"x%d_y%d", _xCoordinate, _yCoordinate);
}

@end
