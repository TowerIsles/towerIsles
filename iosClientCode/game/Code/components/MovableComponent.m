#import "MovableComponent.h"

@implementation MovableComponent

- (NSDictionary*)serializedRepresentationForConfigFile
{
    NSMutableDictionary* output = [NSDictionary object];
    
    NSMutableDictionary* sceneNodeConfigOutput = [_sceneNodeConfig serializedRepresentation];
    
    [Util removeDefaultValuesFromDictionary:sceneNodeConfigOutput];
    
    if (!_sceneNodeConfig.useInitialTransform)
    {
        [sceneNodeConfigOutput removeObjectForKey:@"useInitialTransform"];
        [sceneNodeConfigOutput removeObjectForKey:@"initialPosition"];
        [sceneNodeConfigOutput removeObjectForKey:@"initialScale"];
        [sceneNodeConfigOutput removeObjectForKey:@"initialOrientation"];
    }
    
    if (!_sceneNodeConfig.inheritScale)
        [sceneNodeConfigOutput removeObjectForKey:@"inheritScale"];
    
    if (!_sceneNodeConfig.inheritOrientation)
        [sceneNodeConfigOutput removeObjectForKey:@"inheritOrientation"];
    
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
    
    if (!_sceneNodeConfig.inheritScale)
        [sceneNodeConfigOutput removeObjectForKey:@"inheritScale"];
    
    if (!_sceneNodeConfig.inheritOrientation)
        [sceneNodeConfigOutput removeObjectForKey:@"inheritOrientation"];
    
    [output setObject:sceneNodeConfigOutput
               forKey:@"sceneNodeConfig"];
    
    return output;
}

@end
