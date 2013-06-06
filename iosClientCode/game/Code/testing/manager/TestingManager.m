#import "TestingManager.h"
#import "Game.h"
#import "TestSpec.h"
#import "MathTesting.h"
#import "RenderResourceManager.h"

@interface TestingManager ()
{
    EntityManager* entityManager;
    FrameTimeManager* frameTimeManager;
    ServerTimeManager* serverTimeManager;
    SceneManager* sceneManager;
    RenderResourceManager* renderResourceManager;
    TouchManager* touchManager;
    ViewManager* viewManager;
}

@property (nonatomic, retain) TouchChannel* touchChannel;

@end


@implementation TestingManager

- (void)load
{
    NSLog(@"RUNNING TESTS");
    NSLog(@"=============");
    NSLog(@"=============");
    
    RunTestSuite(MathTesting);
    
    NSLog(@"=============");
    
//    performBlockAfterDelay(2, ^{
//        [self.director reload];
//    });
//    [self.director registerUpdateBlockAtFPS:30
//                                updateBlock:^{
//                                    [self update];//NSLog(@"30 HZ");
//                                }];
//
//    [self.director registerUpdateBlockAtFPS:5
//                                updateBlock:^{
//        NSLog(@"5 HZ");
//    }];
//    
//    [self.director registerUpdateBlockAtFPS:1
//                                updateBlock:^{
//                                    NSLog(@"1 HZ");
//                                }];
    
    TouchChannelConfig* touchChannelConfig = [TouchChannelConfig object];
    
    touchChannelConfig.observeTap = YES;
    touchChannelConfig.observeLongPress = YES;
    touchChannelConfig.observePan = YES;
    touchChannelConfig.observePinch = YES;
    
    self.touchChannel = [touchManager createTouchChannelForView:(UIView*)viewManager.getGLKView
                                                     withConfig:touchChannelConfig];
    
    [self.director registerUpdateBlock:^{
        [self update];
    }];
    
    
    performBlockAfterDelay(0, ^{
        [entityManager createEntitySpecFromEntityConfigId:@"entityConfig_box"];
    });

    performBlockAfterDelay(0, ^{
        [self internal_createAndPopulateTestScene];
    });
}

- (void)reload
{
//    performBlockAfterDelay(5, ^{
//        NSLog(@"function by...");
//    });
//    
//    performBlockAfterDelay(2, ^{
//        [self.director reload];
//    });
}

- (void)update
{
    if (_touchChannel.tapGesture.isActive)
        NSLog(@"tap is active");
    if (_touchChannel.longPressGesture.isActive)
        NSLog(@"longpress is active");
    if (_touchChannel.panGesture.isActive)
        NSLog(@"pan is active");
    if (_touchChannel.pinchGesture.isActive)
        NSLog(@"pinch is active");
//    NSLog(@"%lld", serverTimeManager.getCurrentTimeInMs);
//    for (int i = 0; i < 1000; ++i)
//    {
//        EntitySpec* entity = [entityManager createEntitySpecFromEntityConfigId:@"entityConfig_1"];
//        TestSpec* testSpec = entity.transformedToTestSpec;
//        TestSpecTwo* testSpecTwo = testSpec.transformedToTestSpecTwo;
//        testSpecTwo = testSpecTwo;
//        [entity queueDestruction];
//    }
 //   [self.director reload];

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
    
    Vec3 axis = Vec3Normalized(&Vec3_UnitScale);
    addSceneNode(Vec3Make(0, -2, -10.f), Vec3_UnitScale, QuatMakeAxisAngle(&axis, 0.5f), @"node1", @"test", @"baseShader", @"colorPurple");

    Vec3 axis2 = Vec3Make(10, 2, 1);
    Vec3Normalize(&axis2);
    addSceneNode(Vec3Make(0, 2.f, -10.f), Vec3Make(1, 1, 1), QuatMakeAxisAngle(&axis2, 1.0f), @"node2", @"test2", @"baseShader", @"colorBlue");
    
    addSceneNode(Vec3Make(0, 0, -5.f), Vec3Make(10, 10, 10), QuatMakeAxisAngle(&Vec3_UnitX, M_PI_2), @"node3", @"test", @"baseShader", @"colorWhite");
}

@end
