#import "MovableComponent.h"

@implementation MovableComponent

- (NSDictionary*)serializedRepresentationForConfigFile
{
    NSMutableDictionary* output = [NSDictionary object];
    
    NSMutableDictionary* sceneNodeConfigOutput = [_sceneNodeConfig serializedRepresentation];
    
    if (!_sceneNodeConfig.useInitialTransform)
    {
        [sceneNodeConfigOutput removeObjectForKey:@"useInitialTransform"];
        [sceneNodeConfigOutput removeObjectForKey:@"initialPosition"];
        [sceneNodeConfigOutput removeObjectForKey:@"initialScale"];
        [sceneNodeConfigOutput removeObjectForKey:@"initialOrientation"];
    }
    
    [output setObject:sceneNodeConfigOutput
               forKey:@"sceneNodeConfig"];
    
    return output;
}

- (NSDictionary*)serializedRepresentationForOfflineDatabase
{
    NSMutableDictionary* output = [NSDictionary object];
    
    NSMutableDictionary* sceneNodeConfigOutput = [_sceneNodeConfig serializedRepresentation];
    
    if (!_sceneNodeConfig.useInitialTransform)
    {
        [sceneNodeConfigOutput removeObjectForKey:@"useInitialTransform"];
        [sceneNodeConfigOutput removeObjectForKey:@"initialPosition"];
        [sceneNodeConfigOutput removeObjectForKey:@"initialScale"];
        [sceneNodeConfigOutput removeObjectForKey:@"initialOrientation"];
    }
    
    [output setObject:sceneNodeConfigOutput
               forKey:@"sceneNodeConfig"];
    
    return output;
}

@end
