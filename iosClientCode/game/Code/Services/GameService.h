#if OFFLINE

#define GameServiceCommand(commandName, inputType, outputType, stubbedOutputBlock)                \
ImplementStubbedServiceCommand(commandName, inputType, outputType, stubbedOutputBlock)

#define GameServiceComandNoInput(commandName, outputType, stubbedOutputNoInputBlock)              \
ImplementStubbedServiceCommandNoInput(commandName, outputType, stubbedOutputNoInputBlock)

#define GameServiceCommandNoResponse(commandName, inputType, stubbedBlockArg)                     \
ImplementStubbedServiceCommandNoResponse(commandName, inputType, stubbedBlockArg)

#define GameServiceCommandNoInputNoResponse(commandName, stubbedBlockArg)                         \
ImplementStubbedServiceCommandNoInputNoResponse(commandName, stubbedBlockArg)

#else

#define GameServiceCommand(commandName, inputType, outputType, stubbedOutputBlock)                \
ImplementServiceCommand(commandName, inputType, outputType)

#define GameServiceComandNoInput(commandName, outputType, stubbedOutputNoInputBlock)              \
ImplementServiceCommandNoInput(commandName, outputType)

#define GameServiceCommandNoResponse(commandName, inputType, stubbedBlockArg)                     \
ImplementCommandNoResponse(commandName, inputType)

#define GameServiceCommandNoInputNoResponse(commandName, stubbedBlockArg)                         \
ImplementCommandNoInputNoResponse(commandName)

#endif