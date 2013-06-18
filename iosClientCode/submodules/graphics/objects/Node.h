#import "NSObject+Object.h"
#import "Vec3.h"
#import "Quat.h"
#import "Mat4.h"
#import "Identifier.h"
#import <GLKit/GLKit.h>

@class Camera;

@interface NodeConfig : ManagedPropertiesObject <SerializeByDefault>
@property (nonatomic, assign) BOOL inheritScale;
@property (nonatomic, assign) BOOL inheritOrientation;
@property (nonatomic, assign) Vec3 position;
@property (nonatomic, assign) Vec3 scale;
@property (nonatomic, assign) Quat orientation;

@property (nonatomic, assign) BOOL useInitialTransform;
@property (nonatomic, assign) Vec3 initialPosition;
@property (nonatomic, assign) Vec3 initialScale;
@property (nonatomic, assign) Quat initialOrientation;
@end

@interface Node : ManagedPropertiesObject

@property (nonatomic, assign) BOOL inheritScale;
@property (nonatomic, assign) BOOL inheritOrientation;

- (Node*)getParent;

- (void)configureWithIdentifier:(Identifier*)nodeIdentifier
                     nodeConfig:(NodeConfig*)nodeConfig;

- (void)addChildNode:(Node*)child;

- (void)removeChild:(Node*)child;

- (void)bakeTransformAndRenderWithCamera:(Camera*)camera;

- (void)renderWithCamera:(Camera*)camera;

GLKMatrix4* Node_getTransform(Node* node);

Vec3 Node_getPosition(Node* node);

void Node_setPosition(Node* node, const Vec3* position);

Vec3 Node_getScale(Node* node);

void Node_setScale(Node* node, const Vec3* scale);

Quat Node_getOrientation(Node* node);

void Node_setOrientation(Node* node, const Quat* orientation);

void Node_resetOrientation(Node* node);

void Node_scale(Node* node, const Vec3* scale);

void Node_scaleXYZ(Node* node, float x, float y, float z);

void Node_translate(Node* node, const Vec3* translation);

void Node_translateXYZ(Node* node, float x, float y, float z);

void Node_roll(Node* node, float radianAngle);

void Node_pitch(Node* node, float radianAngle);

void Node_yaw(Node* node, float radianAngle);

void Node_rotate(Node* node, const Quat* quat);

void Node_rotateAxisAngle(Node* node, const Vec3* axis, float radianAngle);

@end
