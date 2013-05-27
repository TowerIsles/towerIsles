
struct Vec3 {
    float x;
    float y;
    float z;
};
typedef struct Vec3 Vec3;

extern const Vec3 Vec3_Zero;
extern const Vec3 Vec3_UnitX;
extern const Vec3 Vec3_UnitY;
extern const Vec3 Vec3_UnitZ;
extern const Vec3 Vec3_NegativeUnitX;
extern const Vec3 Vec3_NegativeUnitY;
extern const Vec3 Vec3_NegativeUnitZ;
extern const Vec3 Vec3_UnitScale;

void Vec3Set(Vec3* v1, const Vec3* v2);

Vec3 Vec3MakeZero();

Vec3 Vec3Make(float x, float y, float z);

void Vec3Add(Vec3* v1, const Vec3* v2);

Vec3 Vec3Added(const Vec3* v1, const Vec3* v2);

void Vec3Subtract(Vec3* v1, const Vec3* v2);

Vec3 Vec3Subtracted(const Vec3* v1, const Vec3* v2);

void Vec3VecScale(Vec3* v1, const Vec3* v2);

Vec3 Vec3VecScaled(Vec3* v1, const Vec3* v2);

void Vec3Scale(Vec3* v1, float scalar);

Vec3 Vec3Scaled(const Vec3* v1, float scalar);

float Vec3Magnitude(const Vec3* v1);

float Vec3MagnitudeSquared(const Vec3* v1);

void Vec3Normalize(Vec3* v1);

Vec3 Vec3Normalized(const Vec3* v1);

float Vec3Distance(const Vec3* v1, const Vec3* v2);

BOOL Vec3IsZero(const Vec3* v1);

BOOL Vec3IsNotZero(const Vec3* v1);

float Vec3Dot(const Vec3* v1, const Vec3* v2);

float Vec3RadianAngleBetween(const Vec3* v1, const Vec3* v2);

Vec3 Vec3CrossProduct(const Vec3* v1, const Vec3* v2);

void Vec3Display(const Vec3* v1);


#define SerializationHandler_Vec3(propertyNameArg, ivarNameArg)      \
- (NSDictionary*)serialize_##propertyNameArg                         \
{                                                                    \
    return DictionaryKO(@"x", Float(ivarNameArg.x),                  \
                        @"y", Float(ivarNameArg.y),                  \
                        @"z", Float(ivarNameArg.z));                 \
}

#define DeserializationHandler_Vec3(classArg, propertyNameArg, ivarNameArg)       \
{                                                                                 \
    CheckTrue([self isSubclassOfClass:[classArg class]])                          \
    [self registerDeserializer:^(classArg* instance, NSDictionary* value) {       \
        instance->ivarNameArg.x = [[value objectForKey:@"x"] floatValue];         \
        instance->ivarNameArg.y = [[value objectForKey:@"y"] floatValue];         \
        instance->ivarNameArg.z = [[value objectForKey:@"z"] floatValue];         \
    }                                                                             \
    forProperty:@#propertyNameArg];                                               \
}
