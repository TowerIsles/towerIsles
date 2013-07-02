#import "TestingManager.h"
#import "Game.h"
#import "TestSpec.h"
#import "MathTesting.h"
#import "SerializationTesting.h"
#import "RenderResourceManager.h"
#import "MovableSpec.h"
#import "MovableComponent.h"
#import "PlayerManager.h"
#import "DefrostManager.h"

@interface TestingManager ()
{
    EntityManager* entityManager;
    FrameTimeManager* frameTimeManager;
    ServerTimeManager* serverTimeManager;
    SceneManager* sceneManager;
    RenderResourceManager* renderResourceManager;
    PlayerManager* playerManager;
    DefrostManager* defrostManager;
}

@end


@implementation TestingManager

- (void)load
{
    NSLog(@"RUNNING TESTS");
    NSLog(@"=============");
    NSLog(@"=============");
    
    RunTestSuite(MathTesting);
    RunTestSuite(SerializationTesting);
    
    NSLog(@"=============");
    
    [self.director registerUpdateBlock:^{
        [self update];
    }];

    performBlockAfterDelay(1, ^{
//        [self internal_createAndLoginWithPlayer];
    });
    
    performBlockAfterDelay(2, ^{
        [self internal_createAndPopulateTestScene];
    });
}

- (void)reload
{
}

- (void)update
{
}

- (void)internal_createAndLoginWithPlayer
{
    [playerManager createNewPlayerWithLoginId:@"caleb"
                                     password:@"caleb"
                                      confirm:@"caleb"
                                 successBlock:^(CreateNewPlayerResponse* createNewPlayerResponse) {
                                     [playerManager loginPlayerWithLoginId:@"caleb"
                                                                  password:@"caleb"
                                                              successBlock:^(LoginResponse* loginResponse) {
                                                                  [defrostManager defrostLoginResponse:loginResponse];
                                                              }
                                                              failureBlock:^{
                                                                  AssertNow();
                                                              }];
                                 }
                                 failureBlock:^{
                                     AssertNow();
                                 }];
}

- (void)internal_createAndPopulateTestScene
{
    SceneConfig* sceneConfig = [SceneConfig object];;
    Scene* testScene = [sceneManager createSceneWithIdentifier:[Identifier objectWithStringIdentifier:@"testScene"]
                                                   sceneConfig:sceneConfig];
    
    [sceneManager setActiveScene:testScene];
    
    void (^addSceneNode)(Vec3, Vec3, Quat, NSString*, NSString*, NSString*, NSString*) = ^(Vec3 position, Vec3 scale, Quat orientation, NSString* nodeName, NSString* meshName, NSString* shaderName, NSString* materialName) {
        
        SceneNodeConfig* sceneNodeConfig = [SceneNodeConfig object];

        sceneNodeConfig.position = position;
        sceneNodeConfig.scale = scale;
        sceneNodeConfig.orientation = orientation;
        
        SceneNode* node1 = [testScene createAndAddSceneNodeWithIdentifer:[Identifier objectWithStringIdentifier:nodeName]
                                                         sceneNodeConfig:sceneNodeConfig
                                                    parentNodeIdentifier:nil];
        
        Model* model = [Model object];
        
        [model addMesh:[renderResourceManager meshForIdentifier:[Identifier objectWithStringIdentifier:meshName]]];
        
        [model addShader:[renderResourceManager shaderForIdentifier:[Identifier objectWithStringIdentifier:shaderName]]];
        
        [model addMaterial:[renderResourceManager materialForIdentifier:[Identifier objectWithStringIdentifier:materialName]]];
        
        [node1 addRenderable:model];
        
    };
    
    addSceneNode = addSceneNode;
    
//    Vec3 axis = Vec3Normalized(&Vec3_UnitScale);
//    addSceneNode(Vec3Make(0, -2, -10.f), Vec3_UnitScale, QuatMakeAxisAngle(&axis, 0.5f), @"node1", @"test", @"baseShader", @"colorPurple");
//
//    Vec3 axis2 = Vec3Make(10, 2, 1);
//    Vec3Normalize(&axis2);
//    addSceneNode(Vec3Make(0, 2.f, -10.f), Vec3Make(1, 1, 1), QuatMakeAxisAngle(&axis2, 1.0f), @"node2", @"test2", @"baseShader", @"colorBlue");
//    
//    addSceneNode(Vec3Make(0, 0, -5.f), Vec3Make(10, 10, 10), QuatMakeAxisAngle(&Vec3_UnitX, M_PI_2), @"node3", @"test", @"baseShader", @"colorWhite");
//    
    
    EntitySpec* one = [entityManager createEntitySpecFromEntityConfigId:@"entityConfig_box"];
    [one.transformedToMovableSpec setPosition:Vec3Make(0, 0, -1)];
    EntitySpec* two = [entityManager createEntitySpecFromEntityConfigId:@"entityConfig_box"];
    [two.transformedToMovableSpec setPosition:Vec3Make(-1, 0, 0)];
    EntitySpec* three = [entityManager createEntitySpecFromEntityConfigId:@"entityConfig_box"];
    [three.transformedToMovableSpec setPosition:Vec3Make(0, -1, 0)];
    EntitySpec* four = [entityManager createEntitySpecFromEntityConfigId:@"entityConfig_box"];
    [four.transformedToMovableSpec setPosition:Vec3Make(1, 0, 0)];
}

@end
