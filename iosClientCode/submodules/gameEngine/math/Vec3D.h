
struct Vec3D {
    float x;
    float y;
    float z;
};
typedef struct Vec3D Vec3D;

Vec3D Vec3DMakeZero();

Vec3D Vec3DMake(float x, float y, float z);

void Vec3DAdd(Vec3D* v1, const Vec3D* v2);

Vec3D Vec3DAdded(const Vec3D* v1, const Vec3D* v2);

void Vec3DSubtract(Vec3D* v1, const Vec3D* v2);

Vec3D Vec3DSubtracted(const Vec3D* v1, const Vec3D* v2);

void Vec3DScale(Vec3D* v1, float scalar);

Vec3D Vec3DScaled(const Vec3D* v1, float scalar);

float Vec3DMagnitude(const Vec3D* v1);

float Vec3DMagnitudeSquared(const Vec3D* v1);

void Vec3DNormalize(Vec3D* v1);

Vec3D Vec3DNormalized(const Vec3D* v1);

float Vec3DDistance(const Vec3D* v1, const Vec3D* v2);

BOOL Vec3DIsZero(const Vec3D* v1);

BOOL Vec3DIsNotZero(const Vec3D* v1);

float Vec3DDot(const Vec3D* v1, const Vec3D* v2);

float Vec3DRadianAngleBetween(const Vec3D* v1, const Vec3D* v2);

Vec3D Vec3DCrossProduct(const Vec3D* v1, const Vec3D* v2);

void Vec3DDisplay(const Vec3D* v1);
// TODO

// on to QUAT! - vec4d may be necessary.woohoo.

// Implement the following
//float Vector2DRadianAngleBetween(const Vector2D v1, const Vector2D v2);
//Vector2D Vector2DDirectionFromRadianAngle(float radianAngle);
