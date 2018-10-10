
// ## : 连接字符串和参数
#define singleton_h(name) + (instancetype)shared##name;

#define singleton_m(name) \
static id _instance; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
 \
+ (instancetype)shared##name \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [NSKeyedUnarchiver unarchiveObjectWithFile:logindUserPath]; \
    }); \
    return _instance; \
} \
 \
//JZZUser *user =