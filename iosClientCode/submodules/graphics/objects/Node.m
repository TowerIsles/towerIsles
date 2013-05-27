#import "Node.h"
#import "Vec3.h"
#import "Quat.h"
#import "Asserts.h"

@implementation NodeConfig

- (Vec3*)positionPointer { return &_position; }
- (Vec3*)scalePointer { return &_scale; }
- (Quat*)orientationPointer { return &_orientation; }

@end

@interface Node ()
{
	
}

@property (nonatomic, retain) Identifier* identifier;

@property (nonatomic, retain) Node* parentNode;
@property (nonatomic, retain) NSMutableArray* childNodes;

@property (nonatomic, assign) Vec3 initialPosition;
@property (nonatomic, assign) Vec3 intialScale;
@property (nonatomic, assign) Quat initialOrientation;

@property (nonatomic, assign) Vec3 nodePosition;
@property (nonatomic, assign) Vec3 nodeScale;
@property (nonatomic, assign) Quat nodeOrientation;

@property (nonatomic, assign) Vec3 derivedPosition;
@property (nonatomic, assign) Vec3 derivedScale;
@property (nonatomic, assign) Quat derivedOrientation;

@property (nonatomic, assign) Mat4 cachedTransform;
@property (nonatomic, assign) BOOL cachedTransformUpToDate;

@end


@implementation Node

- (id)init
{
    if (self = [super init])
    {
        _childNodes = [NSMutableArray object];
    }
    return self;
}

- (Node*)getParent
{
    return _parentNode;
}

- (void)configureWithIdentifier:(Identifier*)nodeIdentifier
                     nodeConfig:(NodeConfig*)nodeConfig;
{
    CheckNotNull(nodeIdentifier);
    CheckNotNull(nodeConfig);
    
    self.identifier = [Identifier objectWithStringIdentifier:nodeIdentifier.stringValue];
    
    Vec3Set(&_nodePosition, nodeConfig.positionPointer);
    
    Vec3Set(&_nodeScale, nodeConfig.scalePointer);
    
    QuatSet(&_nodeOrientation, nodeConfig.orientationPointer);
    
    _inheritScale = nodeConfig.inheritScale;
    
    _inheritOrientation = nodeConfig.inheritOrientation;
}

- (void)addChildNode:(Node*)child
{
    CheckTrue(![_childNodes containsObject:child]);
    
    [_childNodes addObject:child];
    
    child->_parentNode = self;
}

- (void)removeChild:(Node*)child
{
    CheckTrue([_childNodes containsObject:child]);
    
    [_childNodes removeObject:child];
    
    child->_parentNode = nil;
}


Vec3 Node_getPosition(Node* node)
{
    return node->_nodePosition;
}

void Node_setPosition(Node* node, const Vec3* position)
{
    Vec3Set(&node->_nodePosition, position);
}

Vec3 Node_getScale(Node* node)
{
    return node->_nodeScale;
}

void Node_setScale(Node* node, const Vec3* scale)
{
    Vec3Set(&node->_nodeScale, scale);
}

Quat Node_getOrientation(Node* node)
{
    return node->_nodeOrientation;
}

void Node_setOrientation(Node* node, const Quat* orientation)
{
    QuatSet(&node->_nodeOrientation, orientation);
}

void Node_resetOrientation(Node* node)
{
    QuatSetIdentity(&node->_nodeOrientation);
}

void Node_scale(Node* node, const Vec3* scale)
{
    Vec3VecScale(&node->_nodeScale, scale);
}

void Node_scaleXYZ(Node* node, float x, float y, float z)
{
    Vec3 scale = Vec3Make(x, y, z);
    Node_scale(node, &scale);
}

void Node_translate(Node* node, const Vec3* translation)
{
    Vec3Add(&node->_nodePosition, translation);
}

void Node_translateXYZ(Node* node, float x, float y, float z)
{
    Vec3 translation = Vec3Make(x, y, z);
    Node_translate(node, &translation);
}

void Node_roll(Node* node, float radianAngle)
{
    Node_rotateAxisAngle(node, &Vec3_UnitZ, radianAngle);
}

void Node_pitch(Node* node, float radianAngle)
{
    Node_rotateAxisAngle(node, &Vec3_UnitX, radianAngle);
}

void Node_yaw(Node* node, float radianAngle)
{
    Node_rotateAxisAngle(node, &Vec3_UnitY, radianAngle);
}

void Node_rotate(Node* node, const Quat* quat)
{
    QuatMultiply(&node->_nodeOrientation, quat);
}

void Node_rotateAxisAngle(Node* node, const Vec3* axis, float radianAngle)
{
    Quat quat = QuatMakeAxisAngle(axis, radianAngle);
    Node_rotate(node, &quat);
}

@end
