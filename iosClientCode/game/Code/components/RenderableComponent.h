#import "Game.h"

@class Renderable;

@interface RenderableComponent : EntityComponent

@property (nonatomic, retain) Renderable* renderable;

@property (nonatomic, retain) Identifier* renderResourceIdentifier;
@property (nonatomic, retain) Identifier* shaderIdentifier;
@property (nonatomic, retain) Identifier* materialIdentifier;
@property (nonatomic, assign) int nodeIndex;
@end