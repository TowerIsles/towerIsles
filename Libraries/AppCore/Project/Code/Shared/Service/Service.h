#import "NSObject+Object.h"
#import "AppCoreUtilities.h"

// === Command Declaration ===
#define DeclareServiceCommand(commandNameArg, inputType, outputType)                           \
+ (void)commandNameArg:(inputType*)commandInput                                                \
    responseHandler:(void(^)(outputType*))responseBlock;

// No input
#define DeclareServiceCommandNoInput(commandNameArg, outputType)                               \
+ (void)commandNameArg:(void(^)(outputType*))responseBlock;

// No response
#define DeclareServiceCommandNoResponse(commandNameArg, inputType)                             \
+ (void)commandNameArg:(inputType*)commandInput;

// No input, No response
#define DeclareServiceCommandNoInputNoResponse(commandNameArg)                                 \
+ (void)commandNameArg;


// === Command Implementation ===
#define ImplementServiceCommand(commandNameArg, inputType, outputType)                         \
+ (void)commandNameArg:(inputType*)commandInput                                                \
    responseHandler:(void(^)(outputType*))responseBlock                                     \
{                                                                                           \
    PendingRequestAgent* pendingRequestAgent = [PendingRequestAgent new];                   \
    pendingRequestAgent.serviceName = [self serviceName];                                   \
    pendingRequestAgent.commandName = @#commandNameArg;                                        \
    pendingRequestAgent.commandInput = [(NSMutableDictionary*)commandInput serializedRepresentation];  \
    pendingRequestAgent.responseBlock = (JujuRequestResponseBlock)responseBlock;            \
    pendingRequestAgent.failureBlock = failureBlock;                                        \
    pendingRequestAgent.serverResponseClass = [OutputType class];                           \
                                                                                            \
    [pendingRequestAgent performRequest];                                                   \
    [pendingRequestAgent release];                                                          \
}

// No input
#define ImplementServiceCommandNoInput(commandNameArg, outputType)                             \
+ (void)commandNameArg:(void(^)(outputType*))responseBlock                \
{                                                                                           \
    PendingRequestAgent* pendingRequestAgent = [PendingRequestAgent new];                   \
    pendingRequestAgent.serviceName = [self serviceName];                                   \
    pendingRequestAgent.commandName = @#commandNameArg;                                        \
    pendingRequestAgent.responseBlock = responseBlock;                                      \
    pendingRequestAgent.serverResponseClass = [OutputType class];                           \
                                                                                            \
    [pendingRequestAgent performRequest];                                                   \
    [pendingRequestAgent release];                                                          \
}

// No response
#define ImplementServiceCommandNoResponse(commandNameArg, inputType)                           \
+ (void)commandNameArg:(inputType*)commandInput                                                \
{                                                                                           \
    PendingRequestAgent* pendingRequestAgent = [PendingRequestAgent new];                   \
    pendingRequestAgent.serviceName = [self serviceName];                                   \
    pendingRequestAgent.commandName = @#commandNameArg;                                        \
    pendingRequestAgent.commandInput = [(NSMutableDictionary*)commandInput serializedRepresentation];  \
                                                                                            \
    [pendingRequestAgent performRequest];                                                   \
    [pendingRequestAgent release];                                                          \
}

// No input, No response
#define ImplementServiceCommandNoInputNoResponse(commandNameArg)                               \
+ (void)commandNameArg                                                                         \
{                                                                                           \
    PendingRequestAgent* pendingRequestAgent = [PendingRequestAgent new];                   \
    pendingRequestAgent.serviceName = [self serviceName];                                   \
    pendingRequestAgent.commandName = @#commandNameArg;                                        \
                                                                                            \
    [pendingRequestAgent performRequest];                                                   \
    [pendingRequestAgent release];                                                          \
}


/// === Stubbed Command Implementation ===
#define ImplementStubbedServiceCommand(commandNameArg, inputType, outputType, stubbedOutputBlockArg) \
+ (void)commandNameArg:(inputType*)commandInput                                                \
    responseHandler:(void(^)(outputType*))responseBlock                                     \
{                                                                                           \
    StubbedRequestAgent* stubbedRequestAgent = [StubbedRequestAgent new];                   \
    stubbedRequestAgent.commandName = @#commandNameArg;                                        \
    stubbedRequestAgent.serviceName = [self serviceName];                                   \
    stubbedRequestAgent.stubbedOutputBlock = stubbedOutputBlockArg;                            \
    stubbedRequestAgent.responseBlock = responseBlock;                                      \
    stubbedRequestAgent.commandInput = commandInput;                                        \
                                                                                            \
    [stubbedRequestAgent performRequest];                                                   \
    [stubbedRequestAgent release];\
}

// No input
#define ImplementStubbedServiceCommandNoInput(commandNameArg, outputType, stubbedOutputNoInputBlockArg) \
+ (void)commandNameArg:(void(^)(outputType*))responseBlock                \
{                                                                                           \
    StubbedRequestAgent* stubbedRequestAgent = [StubbedRequestAgent new];                   \
    stubbedRequestAgent.commandName = @#commandNameArg;                                        \
    stubbedRequestAgent.serviceName = [self serviceName];                                   \
    stubbedRequestAgent.stubbedOutputNoInputBlock = stubbedOutputNoInputBlockArg;              \
    stubbedRequestAgent.responseBlock = responseBlock;                                      \
                                                                                            \
    [stubbedRequestAgent performRequest];                                                   \
    [stubbedRequestAgent release];                                                          \
}

// No response
#define ImplementStubbedServiceCommandNoResponse(commandNameArg, inputType, stubbedBlockArg)                    \
+ (void)commandNameArg:(inputType*)commandInput                                                \
{\
    stubbedBlockArg(commandInput);\
}

// No input, No response
#define ImplementStubbedServiceCommandNoInputNoResponse(commandNameArg, stubbedBlockArg)                        \
+ (void)commandNameArg                                                                         \
{\
    stubbedBlockArg();\
}

// Service Name
#define ServiceName(serviceNameArg)                                                         \
+ (NSString*)serviceName                                                                    \
{                                                                                           \
    return @#serviceNameArg;                                                                \
}

@interface Service : ManagedPropertiesObject
@end

@interface RequestAgent : ManagedPropertiesObject
@property (nonatomic, retain) NSString* serviceName;
@property (nonatomic, retain) NSString* commandName;
@end

@interface PendingRequestAgent : RequestAgent
@property (nonatomic, assign) Class serverResponseClass;
@property (nonatomic, retain) NSMutableDictionary* commandInput;
@property (nonatomic, copy) void (^responseBlock)(id);

- (void)performRequest;

@end

@interface StubbedRequestAgent : RequestAgent
@property (nonatomic, retain) id commandInput;
@property (nonatomic, copy) id (^stubbedOutputBlock)(id);
@property (nonatomic, copy) id (^stubbedOutputNoInputBlock)(void);
@property (nonatomic, copy) void (^ responseBlock)(id);

- (void)performRequest;

@end
