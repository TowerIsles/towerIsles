#import "Node.h"
#import "Vec3.h"
#import "Quat.h"
#import "Asserts.h"
#import "Camera.h"

@implementation NodeConfig

- (Vec3*)positionPointer { return &_position; }
- (Vec3*)scalePointer { return &_scale; }
- (Quat*)orientationPointer { return &_orientation; }

+ (void)setupSerialization
{
    DeserializationHandler_Vec3(NodeConfig, position, _position);
    DeserializationHandler_Vec3(NodeConfig, scale, _scale);
    DeserializationHandler_Vec3(NodeConfig, orientation, _orientation);
}

SerializationHandler_Vec3(position, _position);
SerializationHandler_Vec3(scale, _scale);
SerializationHandler_Vec3(orientation, _orientation);

@end

@interface Node ()
{
	
}

@property (nonatomic, retain) Identifier* identifier;

@property (nonatomic, retain) Node* parentNode;
@property (nonatomic, retain) NSMutableArray* childNodes;

@property (nonatomic, assign) Vec3 initialPosition;
@property (nonatomic, assign) Vec3 initialScale;
@property (nonatomic, assign) Quat initialOrientation;

@property (nonatomic, assign) Vec3 nodePosition;
@property (nonatomic, assign) Vec3 nodeScale;
@property (nonatomic, assign) Quat nodeOrientation;

@property (nonatomic, assign) Vec3 derivedPosition;
@property (nonatomic, assign) Vec3 derivedScale;
@property (nonatomic, assign) Quat derivedOrientation;

@property (nonatomic, assign) GLKMatrix4 cachedTransform;
@property (nonatomic, assign) BOOL cachedTransformUpToDate;

@end


@implementation Node

- (id)init
{
    if (self = [super init])
    {
        _childNodes = [NSMutableArray new];
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
    Vec3Set(&_initialPosition, nodeConfig.positionPointer);
    
    Vec3Set(&_nodeScale, nodeConfig.scalePointer);
    Vec3Set(&_initialScale, nodeConfig.scalePointer);
    
    QuatSet(&_nodeOrientation, nodeConfig.orientationPointer);
    QuatSet(&_initialOrientation, nodeConfig.orientationPointer);
    
    _inheritScale = nodeConfig.inheritScale;
    
    _inheritOrientation = nodeConfig.inheritOrientation;
}

- (void)addChildNode:(Node*)child
{
    CheckTrue(![_childNodes containsObject:child]);
    
    [_childNodes addObject:child];
    
    child.parentNode = self;
}

- (void)removeChild:(Node*)child
{
    CheckTrue([_childNodes containsObject:child]);
    
    [_childNodes removeObject:child];
    
    child->_parentNode = nil;
}

- (void)bakeTransformAndRenderWithCamera:(Camera*)camera
{
    [self internal_bakeTransform];

    [self renderWithCamera:camera];
    
    for (Node* node in _childNodes)
    {
        [node bakeTransformAndRenderWithCamera:camera];
    }
}

- (void)renderWithCamera:(Camera*)camera
{
#if DEBUG 
    // Render debug renderable
#endif
}

GLKMatrix4* Node_getTransform(Node* node)
{
    if (!node->_cachedTransformUpToDate)
    {
        // SRT
        GLKMatrix4* m = &node->_cachedTransform;
        
        Vec3* scale = &node->_derivedScale;
        
        Vec3* position = &node->_derivedPosition;
        
        GLKMatrix3 orientation = QuatToMat3(&node->_derivedOrientation);
        
        m->m00 = scale->x * orientation.m00;
        m->m10 = scale->y * orientation.m01;
        m->m20 = scale->z * orientation.m02;
        m->m30 = position->x;
        
        m->m01 = scale->x * orientation.m10;
        m->m11 = scale->y * orientation.m11;
        m->m21 = scale->z * orientation.m12;
        m->m31 = position->y;
        
        m->m02 = scale->x * orientation.m20;
        m->m12 = scale->y * orientation.m21;
        m->m22 = scale->z * orientation.m22;
        m->m32 = position->z;
        
        m->m03 = 0;
        m->m13 = 0;
        m->m23 = 0;
        m->m33 = 1;
        
        node->_cachedTransformUpToDate = true;
    }
    return &node->_cachedTransform;
}

- (void)internal_bakeTransform
{
    if (_parentNode != nil)
    {
        Quat* parentOrientation = &_parentNode->_derivedOrientation;
        
        if (_inheritOrientation)
        {
            _derivedOrientation = QuatMultiplied(&_nodeOrientation, parentOrientation);
        }
        else
        {
            _derivedOrientation = _nodeOrientation;
        }
        
        Vec3* parentScale = &_parentNode->_derivedScale;
        
        if (_inheritScale)
        {
            _derivedScale = Vec3VecScaled(&_nodeScale, parentScale);
        }
        else
        {
            _derivedScale = _nodeScale;
        }
        
        CheckTrue(Vec3IsNotZero(parentScale));
        CheckTrue(Vec3IsNotZero(&_nodeScale));
        CheckTrue(Vec3IsNotZero(&_derivedScale));
        
        Vec3 scaledPosition = Vec3VecScaled(&_nodePosition, parentScale);
        
        _derivedPosition = QuatRotatedVec3(&scaledPosition, parentOrientation);
        
        Vec3Add(&_derivedPosition, &_parentNode->_derivedPosition);
    }
    else
    {
        _derivedPosition = _nodePosition;
        
        _derivedOrientation =  _nodeOrientation;
        
        _derivedScale = _nodeScale;
    }
    
    _cachedTransformUpToDate = false;
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
