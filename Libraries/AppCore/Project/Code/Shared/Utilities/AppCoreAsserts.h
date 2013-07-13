
#define CheckNotNull(argument)                              \
    if (argument == nil)                                    \
    {                                                       \
        assert(false);                                      \
    }

#define CheckTrue(argument)                                 \
    if (!(argument))                                        \
    {                                                       \
        assert(false);                                      \
    }

#define AssertNow()                                         \
    {                                                       \
        assert(false);                                      \
    }

#define CheckIsKindOfClass(argument, classArgument)         \
    if (![argument isKindOfClass:[classArgument class]])    \
    {                                                       \
        assert(false);                                      \
    }