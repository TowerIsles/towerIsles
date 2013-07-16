#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
#define APP_CORE_IOS 0
#define APP_CORE_OSX 1
#else
#define APP_CORE_IOS 1
#define APP_CORE_OSX 0
#endif

#import "AppDirector.h"
#import "ResourceManager.h"
#import "JSONKit.h"
#import "Manager.h"
#import "DisplayLink.h"
#import "ViewManager.h"
#import "DisplayInformation.h"
#import "Identifier.h"
#import "NSObject+Object.h"
#import "NSObject+Serialization.h"
#import "NSString+CamelCase.h"
#import "UpdateBlockAtInterval.h"
#import "Service.h"
#import "AppCoreAsserts.h"
#import "AppCoreUtilities.h"
#import "PerformBlockAfterDelay.h"
#import "Vec2.h"
#import "Vec3.h"
#import "Quat.h"
#import "Mat4.h"
#import "MathValidation.h"

#if APP_CORE_OSX
#import <Cocoa/Cocoa.h>
#elif APP_CORE_IOS
#import "IOSAppDelegate.h"
#import "ViewDirector.h"
#import "ManagedScrollView.h"
#import "ManagedView.h"
#import "PassthroughView.h"
#import "ViewLayer.h"
#endif
