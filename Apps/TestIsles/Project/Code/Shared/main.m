//
//  main.m
//  TestIsles
//
//  Created by Caleb Fisher on 7/8/13.
//  Copyright (c) 2013 Caleb Fisher. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IOSAppDelegate.h"
#import "GameEngineUtilities.h"

int main(int argc, char *argv[])
{
    [Utilities initializeGameEngineClasses];
    
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([IOSAppDelegate class]));
    }
}
