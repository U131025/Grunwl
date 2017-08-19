// Generated by Apple Swift version 3.0.2 (swiftlang-800.0.63 clang-800.0.42.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if !defined(SWIFT_TYPEDEFS)
# define SWIFT_TYPEDEFS 1
# if defined(__has_include) && __has_include(<uchar.h>)
#  include <uchar.h>
# elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
# endif
typedef float swift_float2  __attribute__((__ext_vector_type__(2)));
typedef float swift_float3  __attribute__((__ext_vector_type__(3)));
typedef float swift_float4  __attribute__((__ext_vector_type__(4)));
typedef double swift_double2  __attribute__((__ext_vector_type__(2)));
typedef double swift_double3  __attribute__((__ext_vector_type__(3)));
typedef double swift_double4  __attribute__((__ext_vector_type__(4)));
typedef int swift_int2  __attribute__((__ext_vector_type__(2)));
typedef int swift_int3  __attribute__((__ext_vector_type__(3)));
typedef int swift_int4  __attribute__((__ext_vector_type__(4)));
typedef unsigned int swift_uint2  __attribute__((__ext_vector_type__(2)));
typedef unsigned int swift_uint3  __attribute__((__ext_vector_type__(3)));
typedef unsigned int swift_uint4  __attribute__((__ext_vector_type__(4)));
#endif

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif
#if !defined(SWIFT_CLASS_PROPERTY)
# if __has_feature(objc_class_property)
#  define SWIFT_CLASS_PROPERTY(...) __VA_ARGS__
# else
#  define SWIFT_CLASS_PROPERTY(...)
# endif
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(swift_name)
# define SWIFT_COMPILE_NAME(X) __attribute__((swift_name(X)))
#else
# define SWIFT_COMPILE_NAME(X)
#endif
#if defined(__has_attribute) && __has_attribute(objc_method_family)
# define SWIFT_METHOD_FAMILY(X) __attribute__((objc_method_family(X)))
#else
# define SWIFT_METHOD_FAMILY(X)
#endif
#if defined(__has_attribute) && __has_attribute(noescape)
# define SWIFT_NOESCAPE __attribute__((noescape))
#else
# define SWIFT_NOESCAPE
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_ENUM_EXTRA)
# define SWIFT_ENUM_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
#  define SWIFT_CLASS_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
# define SWIFT_PROTOCOL_NAMED(SWIFT_NAME) SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if !defined(SWIFT_ENUM)
# define SWIFT_ENUM(_type, _name) enum _name : _type _name; enum SWIFT_ENUM_EXTRA _name : _type
# if defined(__has_feature) && __has_feature(generalized_swift_name)
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) enum _name : _type _name SWIFT_COMPILE_NAME(SWIFT_NAME); enum SWIFT_COMPILE_NAME(SWIFT_NAME) SWIFT_ENUM_EXTRA _name : _type
# else
#  define SWIFT_ENUM_NAMED(_type, _name, SWIFT_NAME) SWIFT_ENUM(_type, _name)
# endif
#endif
#if !defined(SWIFT_UNAVAILABLE)
# define SWIFT_UNAVAILABLE __attribute__((unavailable))
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import Foundation;
#endif

#import <ETILinkSDK/ETILinkSDK.h>

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@class NSURLSession;
@class NSURLSessionDataTask;
@class NSURLSessionTask;
@class NSURLAuthenticationChallenge;
@class NSURLCredential;
@class NSURLSessionDownloadTask;

/**
  Absorb all the delegates methods of NSURLSession and forwards them to pretty closures.
  This is basically the sin eater for NSURLSession.
*/
SWIFT_CLASS("_TtC10ETILinkSDK15DelegateManager")
@interface DelegateManager : NSObject <NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
- (void)URLSession:(NSURLSession * _Nonnull)session dataTask:(NSURLSessionDataTask * _Nonnull)dataTask didReceiveData:(NSData * _Nonnull)data;
- (void)URLSession:(NSURLSession * _Nonnull)session task:(NSURLSessionTask * _Nonnull)task didCompleteWithError:(NSError * _Nullable)error;
- (void)URLSession:(NSURLSession * _Nonnull)session task:(NSURLSessionTask * _Nonnull)task didReceiveChallenge:(NSURLAuthenticationChallenge * _Nonnull)challenge completionHandler:(void (^ _Nonnull)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler;
- (void)URLSession:(NSURLSession * _Nonnull)session task:(NSURLSessionTask * _Nonnull)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;
- (void)URLSession:(NSURLSession * _Nonnull)session downloadTask:(NSURLSessionDownloadTask * _Nonnull)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
- (void)URLSession:(NSURLSession * _Nonnull)session downloadTask:(NSURLSessionDownloadTask * _Nonnull)downloadTask didFinishDownloadingToURL:(NSURL * _Nonnull)location;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


/**
  ETILink 对象配置属性
*/
SWIFT_CLASS("_TtC10ETILinkSDK21ETConfigurationOption")
@interface ETConfigurationOption : NSObject
/**
  \code
  etChatTo
  \endcode 发送消息时，使用内网优先的模式
  note:
  该 \code
  userId
  \endcode 的处于<em>内网&外网</em>同时在线时，如果该值为 \code
  true
  \endcode 则优先使用内网通道发送消息。反之，使用外网通道
  默认为 \code
  true
  \endcode
*/
@property (nonatomic) BOOL lanFirst;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface ETConfigurationOption (SWIFT_EXTENSION(ETILinkSDK))
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end


/**
  连接 \code
  设备/服务器
  \endcode 所需参数
*/
SWIFT_CLASS("_TtC10ETILinkSDK12ETConnectOpt")
@interface ETConnectOpt : NSObject
@property (nonatomic) BOOL cleansess;
/**
  心跳时间间隔, 范围为 \code
  15~300s
  \endcode 默认 60s
*/
@property (nonatomic) uint16_t keepAlive;
/**
  连接超时时间 \code
  5-60s
  \endcode. 默认 10s
*/
@property (nonatomic) NSTimeInterval timeOut;
/**
  \param keepAlive 心跳时间

  \param cleansess true, 清除会话信息, 不保存离线消息, 上次会话未发送成功的消息. 不进行消息重发. false: 保存会话信息.

  \param timeOut 连接超时时间

*/
- (nonnull instancetype)initWithKeepAlive:(uint16_t)keepAlive cleansess:(BOOL)cleansess timeOut:(NSTimeInterval)timeOut OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


@interface ETConnectOpt (SWIFT_EXTENSION(ETILinkSDK))
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end


/**
  初始化SDK参数
*/
SWIFT_CLASS("_TtC10ETILinkSDK11ETCreateOpt")
@interface ETCreateOpt : NSObject
/**
  服务器地址
*/
@property (nonatomic, copy) NSString * _Nonnull balancHost;
/**
  服务器端口, 默认 8085
*/
@property (nonatomic) uint16_t balancPort;
/**
  app key
*/
@property (nonatomic, copy) NSString * _Nonnull appKey;
/**
  secret key
*/
@property (nonatomic, copy) NSString * _Nonnull secretKey;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithAppKey:(NSString * _Nonnull)appKey secretKey:(NSString * _Nonnull)secretKey balancHost:(NSString * _Nonnull)balancHost balancPort:(uint16_t)balancPort OBJC_DESIGNATED_INITIALIZER;
@end


@interface ETCreateOpt (SWIFT_EXTENSION(ETILinkSDK))
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end


/**
  发现内网设备，使用的额外参数
*/
SWIFT_CLASS("_TtC10ETILinkSDK16ETDiscoverOption")
@interface ETDiscoverOption : NSObject
/**
  参数内容
*/
@property (nonatomic, copy) NSData * _Nonnull content;
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithString:(NSString * _Nonnull)string OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
@end


@interface ETDiscoverOption (SWIFT_EXTENSION(ETILinkSDK))
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end

typedef SWIFT_ENUM(NSInteger, ETErrorCode) {
  ETErrorCodeNone = 0,
  ETErrorCodeUnknown = 1,
  ETErrorCodeParameErr = 2,
  ETErrorCodeTimeOut = 3,
  ETErrorCodeNetworkException = 4,
  ETErrorCodeNoneServerConnected = 5,
  ETErrorCodeNotDiscoveredServer = 6,
  ETErrorCodePermissionDenied = 7,
  ETErrorCodeHasLostConnection = 8,
  ETErrorCodeReconnectFailed = 9,
  ETErrorCodeBeyondLimit = 10,
  ETErrorCodeConnectAuthErr = 1000,
  ETErrorCodeCloseByRemote = 1001,
  ETErrorCodeLoginElseWhere = 1002,
  ETErrorCodeHasConnected = 1003,
  ETErrorCodeHasDisConnected = 1004,
  ETErrorCodeHttpModuleNotExist = 2000,
  ETErrorCodeHttpRequestErr = 2001,
  ETErrorCodeHttpSvrResponseErr = 2002,
  ETErrorCodeHttpParameErr = 2003,
  ETErrorCodeHttpAppTokenErr = 2004,
  ETErrorCodeHttpServerErr = 2005,
  ETErrorCodeHttpApiInvalid = 2006,
  ETErrorCodeHttpRequestRepeat = 2007,
  ETErrorCodeHttpPermissionDenied = 2008,
  ETErrorCodeHttpNotifyIMFailed = 2009,
  ETErrorCodeHttpBeyondLimit = 2010,
/**
  ///////////////////   文件  操作
*/
  ETErrorCodeFileModuleNotExist = 3000,
  ETErrorCodeFileConfigureErr = 3001,
  ETErrorCodeFileDontExist = 3002,
  ETErrorCodeFileTransferFailed = 3003,
  ETErrorCodeFileIDIsNullOrEmpty = 3004,
  ETErrorCodeFileParameterIll = 3005,
/**
  ///////////////////   AV  操作
*/
  ETErrorCodeAvModuleNotExist = 4000,
  ETErrorCodeAvRequestHasExist = 4001,
  ETErrorCodeAvRequestNotExist = 4002,
  ETErrorCodeAvInviteSendErr = 4003,
  ETErrorCodeAvAcceptSendErr = 4004,
  ETErrorCodeAvRemoteOffline = 4005,
  ETErrorCodeAvRemoteLoginErr = 4006,
  ETErrorCodeAvLocalLoginErr = 4007,
  ETErrorCodeAvMakeCallErr = 4008,
  ETErrorCodeAvSessionTypeErr = 4009,
};


/**
  文件信息对象
*/
SWIFT_CLASS("_TtC10ETILinkSDK10ETFileInfo")
@interface ETFileInfo : NSObject
/**
  文件在服务器上的唯一标示
*/
@property (nonatomic, copy) NSString * _Nonnull fileID;
/**
  文件名称：1.txt
*/
@property (nonatomic, copy) NSString * _Nonnull fileName;
/**
  文件大小
*/
@property (nonatomic, copy) NSString * _Nonnull fileSize;
/**
  文件CRC校验码.(暂定为空.)
*/
@property (nonatomic, copy) NSString * _Nonnull crc;
/**
  文件 Tracker 服务器地址
*/
@property (nonatomic, copy) NSString * _Nonnull ip;
/**
  文件 Tracker 服务器端口
*/
@property (nonatomic) NSUInteger port;
/**
  HTTP(s) 下载地址
*/
@property (nonatomic, copy) NSString * _Nonnull url;
/**
  异常或描述信息.
*/
@property (nonatomic, copy) NSString * _Nonnull descn;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithName:(NSString * _Nonnull)name OBJC_DESIGNATED_INITIALIZER;
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end

@class ETUser;

/**
  群组
*/
SWIFT_CLASS("_TtC10ETILinkSDK7ETGroup")
@interface ETGroup : NSObject
/**
  群组唯一标示
*/
@property (nonatomic, copy) NSString * _Nonnull groupId;
/**
  群组名称
*/
@property (nonatomic, copy) NSString * _Nonnull name;
/**
  群成员
  members = nil 时, 不代表该群没有成员. 也可能是未获取群成员
*/
@property (nonatomic, copy) NSArray<ETUser *> * _Nullable members;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithGroupId:(NSString * _Nonnull)groupId name:(NSString * _Nonnull)name members:(NSArray<ETUser *> * _Nullable)members OBJC_DESIGNATED_INITIALIZER;
@end


@interface ETGroup (SWIFT_EXTENSION(ETILinkSDK))
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end

@class NSError;
enum ETLogLevel : uint8_t;
@protocol ETILinkDelegate;

/**
  ETILinkSDK 核心类
*/
SWIFT_CLASS("_TtC10ETILinkSDK7ETILink")
@interface ETILink : NSObject
/**
  delegate
*/
@property (nonatomic, weak) id <ETILinkDelegate> _Nullable delegate;
/**
  客户端的 User ID. <em>只读</em>
*/
@property (nonatomic, readonly, copy) NSString * _Nonnull uid;
/**
  服务器时间回调
*/
@property (nonatomic, copy) void (^ _Nullable getIlinkTimeHandler)(NSTimeInterval, NSError * _Nullable);
@property (nonatomic, copy) void (^ _Nullable getUserStateHandler)(NSString * _Nonnull, BOOL, NSError * _Nullable);
- (nonnull instancetype)initWithUid:(NSString * _Nonnull)uid option:(ETCreateOpt * _Nonnull)option OBJC_DESIGNATED_INITIALIZER;
/**
  获取 SDK 当前版本号

  returns:
  x.y.z.t (major.minor.patch.build)
*/
+ (NSString * _Nonnull)getSdkVersion;
/**
  设置日志等级
*/
- (void)setLogLevel:(enum ETLogLevel)level;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  注册用户
  \param appKey 

  \param secretKey 

  \param username 注册的用户名

  \param nickname 注册用户的昵称

  \param handler 回调处理

*/
+ (void)addUserWithAppKey:(NSString * _Nonnull)appKey secretKey:(NSString * _Nonnull)secretKey host:(NSString * _Nonnull)host port:(uint16_t)port username:(NSString * _Nonnull)username nickname:(NSString * _Nonnull)nickname handler:(void (^ _Nullable)(ETUser * _Nullable, NSError * _Nullable))handler;
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  发现内网设备或服务器
  note:
  发现成功后将在 \code
  delegate
  \endcode 的回调方法 \code
  etOnServer
  \endcode 或者 \code
  etOnDidDiscoverFailed
  \endcode 进行返回
  \param timeout 搜索超时时间

*/
- (void)discoverServersWithTimeout:(NSTimeInterval)timeout;
/**
  发现内网设备或服务器
  note:
  发现成功后将在 \code
  delegate
  \endcode 的回调方法 \code
  etOnServer
  \endcode 或者 \code
  etOnDidDiscoverFailed
  \endcode 进行返回
  \param timeout 搜索超时时间. 不低于5s

  \param option 搜索内网设备时的搜索选项。

*/
- (void)discoverServersWithTimeout:(NSTimeInterval)timeout option:(ETDiscoverOption * _Nullable)option;
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  存在外网连接的情况, 获取服务器时间
*/
- (void)getIlinkTime;
/**
  获取某用户状态 (外网)
  \param who 用户userID


  returns:
  false 则为未连接外网, 调用失败
*/
- (void)getUserState:(NSString * _Nonnull)who;
@end

@class ETServer;

@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  连接到指定的服务器
  note:
  如果指定的服务器/设备已经连接成功，则会返回已经连接成功的错误
  \param server 所连接的\code
  服务器／设备
  \endcode对象

  \param option 连接参数

  \param handler 回调

*/
- (void)connect:(ETServer * _Nullable)server option:(ETConnectOpt * _Nonnull)option handler:(void (^ _Nullable)(ETServer * _Nullable, NSError * _Nullable))handler;
/**
  重连服务器, 在网络或者其他异常情况断开连接后. 可调用该方法恢复连接
  \param interval 每次重连时间间隔

  \param process 每次重连完成后, 都会回调该函数返回:
  参数一: 代表当次重连的次数
  参数二: 代表此次重连的结果
  参数三: 此次重连的错误信息
  返回值: true, 代表如果失败则继续进行连接. false, 代表如果失败则停止继续重试

*/
- (void)reconnectWithInterval:(NSTimeInterval)interval process:(BOOL (^ _Nonnull)(NSInteger, BOOL, NSError * _Nullable))process;
/**
  断开服务器连接
  note:
  当 \code
  server == nil
  \endcode 时, 则默认为断开所有的服务器或者设备的连接
  \param server 指定需要断开的服务器

*/
- (void)disconnect:(ETServer * _Nullable)server;
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  添加好友
  \param buddyId 好友 User ID

  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)addBuddy:(NSString * _Nonnull)buddyId handler:(void (^ _Nullable)(ETUser * _Nullable, NSError * _Nullable))handler;
/**
  添加好友
  \param buddyId 好友 User ID

  \param isNotify 加好友时是否通知该好友

  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)addBuddy:(NSString * _Nonnull)buddyId isNotify:(BOOL)isNotify handler:(void (^ _Nullable)(ETUser * _Nullable, NSError * _Nullable))handler;
/**
  删除好友
  \param buddyId 好友 User ID

  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)removeBuddy:(NSString * _Nonnull)buddyId handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  删除好友
  \param buddyId 好友 User ID

  \param isNotify 删除好友时是否通知该好友

  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)removeBuddy:(NSString * _Nonnull)buddyId isNotify:(BOOL)isNotify handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  获取好友列表
  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)getBuddies:(void (^ _Nullable)(NSArray<ETUser *> * _Nullable, NSError * _Nullable))handler;
@end

@class ETMessage;
enum ETMessageQos : uint8_t;

@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  发布消息, 仅在外网模式下才会存在 “Publish” 操作
  \param topic 主题, 主题中不能包含 MQTT 中规定的 # + $字符

  \param message 发送的消息

  \param qos Qos

*/
- (void)publish:(NSString * _Nonnull)topic message:(ETMessage * _Nonnull)message qos:(enum ETMessageQos)qos handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  发布消息到某个群
  \param topic 群组 Topic, 主题中不能包含 MQTT 中规定的 # + $ 字符

  \param message 消息体

  \param qos Qos 等级, 可选为 0/1/2

  \param handler 成功或发送失败回调


  returns:
  本次消息 Id
*/
- (void)publishToGroup:(NSString * _Nonnull)groupId message:(ETMessage * _Nonnull)message handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  点对点通信
  \param userId 通信对象的用户ID

  \param message 消息内容


  returns:
  Message ID
*/
- (void)chatTo:(NSString * _Nonnull)userId message:(ETMessage * _Nonnull)message handler:(void (^ _Nullable)(NSError * _Nullable))handler;
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  配置该实例的某些行为属性，全局有效
*/
- (void)setOption:(ETConfigurationOption * _Nonnull)option;
/**
  绑定 \code
  userId
  \endcode 和 \code
  deviceToken
  \endcode
  \param token 通过 APNs 获取的 deviceToken, 然后转化成 \code
  Hex String
  \endcode

  \param handler 回调. 绑定成功或失败的回调

*/
- (void)bindWithDeviceToken:(NSString * _Nonnull)deviceToken handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  解除绑定 \code
  userId
  \endcode 和 \code
  deviceToken
  \endcode
  \param handler 回调. 绑定成功或失败的回调

*/
- (void)unbindDeviceToken:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  拉取离线消息, 消息从 OnMessage 返回
*/
- (void)requestOfflineMessage:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  是否连接到某个服务器
  note:

  \code
  server == nil
  \endcode 时, 默认为云服务器.
  \param server Server


  returns:
  true 已连接, false 未连接
*/
- (BOOL)isConnected:(ETServer * _Nullable)server;
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  主动发送文件给某一个用户
  \param recvUid 接受者 uid

  \param filePath 需要发送的文件的本地 绝对路径

  \param descn 文件描述信息

  \param handler 文件发送 成功/失败 的回调

*/
- (void)fileTo:(NSString * _Nonnull)recvUid filePath:(NSString * _Nonnull)filePath descn:(NSString * _Nonnull)descn handler:(void (^ _Nullable)(ETFileInfo * _Nullable, NSError * _Nullable))handler;
/**
  从文件服务器下载文件
  \param fileInfo 文件信息实例, 必须保证 fileID, ip, port 正确。

  \param localPath 需要下载到的本地路径

  \param handler 文件下载成功或失败的回调

*/
- (void)downloadFile:(ETFileInfo * _Nonnull)fileInfo localPath:(NSString * _Nonnull)localPath handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  上传一个文件到服务器
  \param filePath 需要发送的文件的本地 绝对路径

  \param handler 文件发送 成功/失败 的回调

*/
- (void)uploadFile:(NSString * _Nonnull)filePath handler:(void (^ _Nullable)(ETFileInfo * _Nullable, NSError * _Nullable))handler;
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  订阅主题, 仅在外网模式下才会存在 “Subscribe” 操作
  \param topic 所订阅的主题

  \param qos 订阅消息的 Qos 等级, 当接收该主题消息时, 最大以此 Qos 接收

*/
- (void)subscribe:(NSString * _Nonnull)topic qos:(enum ETMessageQos)qos handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  取消订阅主题, 仅在外网模式下才会存在 “Unsubscribe” 操作
  \param topic 所需要取消的topic

*/
- (void)unsubscribe:(NSString * _Nonnull)topic handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  订阅用户 离线/在线 状态, 订阅成功后将会收到, 在线/离线 消息通知
  \param userID 要订阅对象的 UserID

  \param hadnler 

*/
- (void)subUserState:(NSString * _Nonnull)userId handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  取消订阅用户 离线/在线 状态, 取消后将不会会收到改用户的在线/离线消息通知
  \param userID 要取消订阅对象的 UserID

  \param hadnler 

*/
- (void)unsubUserState:(NSString * _Nonnull)userId handler:(void (^ _Nullable)(NSError * _Nullable))handler;
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
/**
  创建群
  可以通过群名称创建一个群，凭借返回的群ID，就可以发布群信息, 当前创建的UID为群主，拥有群管理权限
  \param groupName 群组名称

  \param userList 所添加的群成员 UserID 列表。单次最多是10名

  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)createGroup:(NSString * _Nonnull)groupName userList:(NSArray<NSString *> * _Nonnull)userList handler:(void (^ _Nullable)(ETGroup * _Nullable, NSError * _Nullable))handler;
/**
  获取用户所在的群组列表
  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)getGroups:(void (^ _Nullable)(NSArray<ETGroup *> * _Nullable, NSError * _Nullable))handler;
/**
  注销群
  注销已存在的群, 群主才具备改权限
  \param groupId 该群的 Id

  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)destroyGroup:(NSString * _Nonnull)groupId handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  用户主动退出群
  \param topic 群组 Topic

  \param handler 回调

*/
- (void)exitGroup:(NSString * _Nonnull)groupId handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  添加群成员
  note:
  只有群主才能调用接口添加群成员
  \param groupId 指定群组的 groupId

  \param userList 所添加的群成员 UserID 列表, 单次操作最多10个

  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)addGroupMembers:(NSString * _Nonnull)groupId userList:(NSArray<NSString *> * _Nonnull)userList handler:(void (^ _Nullable)(NSArray<ETUser *> * _Nullable, NSError * _Nullable))handler;
/**
  删除群成员
  note:
  只有群主可以移除群成员, 群成员移除后不能收到该群任何消息
  \param groupId 指定群组的 groupId

  \param userList 所删除的群成员 UserID 列表, 单次操作最多10个

  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)removeGroupMembers:(NSString * _Nonnull)groupId userList:(NSArray<NSString *> * _Nonnull)userList handler:(void (^ _Nullable)(NSError * _Nullable))handler;
/**
  获取群成员列表
  note:
  必须是群成员才能够查询
  \param groupId 指定群组的groupId

  \param handler 回调处理函数, error = nil 时, 表示操作成功

*/
- (void)getGroupMembers:(NSString * _Nonnull)groupId handler:(void (^ _Nullable)(NSArray<ETUser *> * _Nullable, NSString * _Nullable, NSError * _Nullable))handler;
@end


@interface ETILink (SWIFT_EXTENSION(ETILinkSDK))
@end

enum ETMessageType : NSInteger;
@class ETReceiveMessage;

/**
  ETILink Delegate
*/
SWIFT_PROTOCOL("_TtP10ETILinkSDK15ETILinkDelegate_")
@protocol ETILinkDelegate <NSObject>
@optional
/**
  成功发现设备
  发现次设备都会有一个返回
  \param server 此次所发现的设备

*/
- (void)onServer:(ETServer * _Nonnull)server;
/**
  服务器搜索任务完成.
  当规定的超时时间完成, 必将回调该方法
*/
- (void)onDiscoverCompelated;
/**
  异常掉线回调
  \param server 被断开连接的设备, 当 server.type = .Server 时, 为已断开MQTT服务器

  \param error 连接断开的错误描述, \code
  当 error == nil
  \endcode 则为主动的正常断开

*/
- (void)onBroken:(ETServer * _Nonnull)server error:(NSError * _Nullable)error;
/**
  接收到从 设备/服务器 发来的消息
  \param type 消息类型

  \param topic type = .ChatTo 时, topic 为 UserID

  \param message Message

*/
- (void)onMessage:(enum ETMessageType)type topic:(NSString * _Nullable)topic sender:(NSString * _Nullable)sender message:(ETReceiveMessage * _Nonnull)message;
/**
  获取用户状态消息回调
  \param userID 用户ID

  \param state 在线状态

*/
- (void)onQuery:(NSString * _Nonnull)userID state:(BOOL)state;
/**
  当自己被别人添加为好友时, 回调
  \param buddyUid 添加者 UID

*/
- (void)onAddedBuddyBy:(NSString * _Nonnull)buddyUid;
/**
  收到被别人删除好友关系通知时, 回调
  \param buddyUid 添加者 UID

*/
- (void)onRemovedBuddyBy:(NSString * _Nonnull)buddyUid;
/**
  收到一个文件
  \param senderUid 发送者 User ID

  \param fileInfo 请求的文件消息

*/
- (void)onFileRecved:(NSString * _Nonnull)senderUid fileInfo:(ETFileInfo * _Nonnull)fileInfo;
@end

typedef SWIFT_ENUM(uint8_t, ETLogLevel) {
/**
  不显示日志
*/
  ETLogLevelOff = 0,
/**
  显示 错误 日志
*/
  ETLogLevelError = 1,
/**
  显示 错误|警告 日志
*/
  ETLogLevelWarning = 2,
/**
  显示 错误|警告|调试 日志
*/
  ETLogLevelDebug = 3,
/**
  显示 错误|警告|调试|信息 日志
*/
  ETLogLevelInfo = 4,
/**
  显示 错误|警告|调试|信息|冗余 日志
*/
  ETLogLevelVerbose = 5,
};


/**
  消息对象, 内部为字节流
*/
SWIFT_CLASS("_TtC10ETILinkSDK9ETMessage")
@interface ETMessage : NSObject
@property (nonatomic, copy) NSData * _Nonnull stream;
@property (nonatomic, readonly, copy) NSArray<NSNumber *> * _Nonnull bytes;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithStream:(NSData * _Nonnull)stream OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithBytes:(NSArray<NSNumber *> * _Nonnull)bytes OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithStr:(NSString * _Nonnull)str OBJC_DESIGNATED_INITIALIZER;
@end


@interface ETMessage (SWIFT_EXTENSION(ETILinkSDK))
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end

/**
  消息质量服务等级 (Quality of Service)
*/
typedef SWIFT_ENUM(uint8_t, ETMessageQos) {
/**
  “至多一次”. 消息发布完全依赖底层 TCP/IP 网络。会发生消息丢失或重复。这一级别可用于如下情况，环境传感器数据，丢失一次读记录无所谓
*/
  ETMessageQosQos0 = 0,
/**
  “至少一次”. 确保消息到达，但消息重复可能会发生。
*/
  ETMessageQosQos1 = 1,
/**
  “只有一次”. 确保消息到达一次。这一级别可用于如下情况，在计费系统中，消息重复或丢失会导致不正确的结果。
*/
  ETMessageQosQos2 = 2,
};

/**
  消息类型枚举
*/
typedef SWIFT_ENUM(NSInteger, ETMessageType) {
  ETMessageTypeChatTo = 0,
  ETMessageTypePublish = 1,
  ETMessageTypeGroup = 2,
};


/**
  收到的消息
*/
SWIFT_CLASS("_TtC10ETILinkSDK16ETReceiveMessage")
@interface ETReceiveMessage : ETMessage
/**
  消息 Id
*/
@property (nonatomic) uint16_t id;
/**
  消息服务质量, 0 ~ 2
*/
@property (nonatomic) enum ETMessageQos qos;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
- (nonnull instancetype)initWithStream:(NSData * _Nonnull)stream SWIFT_UNAVAILABLE;
- (nonnull instancetype)initWithBytes:(NSArray<NSNumber *> * _Nonnull)bytes SWIFT_UNAVAILABLE;
- (nonnull instancetype)initWithStr:(NSString * _Nonnull)str SWIFT_UNAVAILABLE;
@end


@interface ETReceiveMessage (SWIFT_EXTENSION(ETILinkSDK))
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end

enum ETServerType : uint8_t;

/**
  Server
*/
SWIFT_CLASS("_TtC10ETILinkSDK8ETServer")
@interface ETServer : NSObject
/**
  服务器 UserID, 云服务器恒为 \code
  proxy_server
  \endcode
*/
@property (nonatomic, copy) NSString * _Nonnull userID;
/**
  服务器地址
*/
@property (nonatomic, copy) NSString * _Nonnull host;
/**
  消息服务端口
*/
@property (nonatomic) uint16_t port;
/**
  服务类型
*/
@property (nonatomic) enum ETServerType type;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithUserID:(NSString * _Nonnull)userID host:(NSString * _Nonnull)host port:(uint16_t)port type:(enum ETServerType)type OBJC_DESIGNATED_INITIALIZER;
@end


@interface ETServer (SWIFT_EXTENSION(ETILinkSDK))
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end

/**
  消息服务器类型
*/
typedef SWIFT_ENUM(uint8_t, ETServerType) {
/**
  局域网
*/
  ETServerTypeLan = 0,
/**
  云服务器
*/
  ETServerTypeServer = 1,
};


/**
  用户
*/
SWIFT_CLASS("_TtC10ETILinkSDK6ETUser")
@interface ETUser : NSObject
/**
  用户唯一标示
*/
@property (nonatomic, copy) NSString * _Nonnull userID;
/**
  用户昵称
*/
@property (nonatomic, copy) NSString * _Nonnull nickName;
/**
  用户名
*/
@property (nonatomic, copy) NSString * _Nonnull userName;
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithUid:(NSString * _Nonnull)uid name:(NSString * _Nonnull)name nick:(NSString * _Nonnull)nick OBJC_DESIGNATED_INITIALIZER;
@end


@interface ETUser (SWIFT_EXTENSION(ETILinkSDK))
@property (nonatomic, readonly, copy) NSString * _Nonnull description;
@end


@interface GCDAsyncSocket (SWIFT_EXTENSION(ETILinkSDK))
@end

@class NSMutableURLRequest;

/**
  The class that does the magic. Is a subclass of NSOperation so you can use it with operation queues or just a good ole HTTP request.
*/
SWIFT_CLASS("_TtC10ETILinkSDK4HTTP")
@interface HTTP : NSOperation
/**
  This is for handling authenication
*/
@property (nonatomic, copy) NSURLCredential * _Nullable (^ _Nullable auth)(NSURLAuthenticationChallenge * _Nonnull);
/**
  This is for monitoring progress
*/
@property (nonatomic, copy) void (^ _Nullable progress)(float);
/**
  This is for handling downloads
*/
@property (nonatomic, copy) void (^ _Nullable downloadHandler)(NSURL * _Nonnull);
/**
  creates a new HTTP request.
*/
- (nonnull instancetype)init:(NSURLRequest * _Nonnull)req session:(NSURLSession * _Nonnull)session isDownload:(BOOL)isDownload OBJC_DESIGNATED_INITIALIZER;
/**
  Returns if the task is asynchronous or not. NSURLSessionTask requests are asynchronous.
*/
@property (nonatomic, readonly) BOOL isAsynchronous;
@property (nonatomic, readonly) BOOL isReady;
/**
  Returns if the task is current running.
*/
@property (nonatomic, readonly) BOOL isExecuting;
@property (nonatomic, readonly) BOOL isFinished;
/**
  Start the HTTP task. Make sure to set the onFinish closure before calling this to get a response.
*/
- (void)start;
/**
  Cancel the running task
*/
- (void)cancel;
/**
  Sets the task to finished.
  If you aren’t using the DelegateManager, you will have to call this in your delegate’s URLSession:dataTask:didCompleteWithError: method
*/
- (void)finish;
/**
  Check not executing or finished when adding dependencies
*/
- (void)addDependency:(NSOperation * _Nonnull)operation;
/**
  Set the global auth handler
*/
+ (void)globalAuth:(NSURLCredential * _Nullable (^ _Nullable)(NSURLAuthenticationChallenge * _Nonnull))handler;
/**
  Set the global request handler
*/
+ (void)globalRequest:(void (^ _Nullable)(NSMutableURLRequest * _Nonnull))handler;
- (nonnull instancetype)init SWIFT_UNAVAILABLE;
@end


@interface NSLock (SWIFT_EXTENSION(ETILinkSDK))
@end


@interface NSMutableURLRequest (SWIFT_EXTENSION(ETILinkSDK))
/**
  Convenience init to allow init with a string.
  -parameter urlString: The string representation of a URL to init with.
*/
- (nullable instancetype)initWithUrlString:(NSString * _Nonnull)urlString;
/**
  Check if the request requires the parameters to be appended to the URL
*/
- (BOOL)isURIParam;
@end


@interface NSNumber (SWIFT_EXTENSION(ETILinkSDK))
@end

@class NSCoder;

/**
  This is how to upload files in SwiftHTTP. The upload object represents a file to upload by either a data blob or a url (which it reads off disk).
*/
SWIFT_CLASS("_TtC10ETILinkSDK6Upload")
@interface Upload : NSObject <NSCoding>
/**
  Reads the data from disk or from memory. Throws an error if no data or file is found.
*/
- (NSData * _Nullable)getDataAndReturnError:(NSError * _Nullable * _Nullable)error;
/**
  Standard NSCoder support
*/
- (void)encodeWithCoder:(NSCoder * _Nonnull)aCoder;
/**
  Required for NSObject support (because of NSCoder, it would be a struct otherwise!)
*/
- (nonnull instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithCoder:(NSCoder * _Nonnull)aDecoder;
/**
  Initializes a new Upload object with a fileUrl. The fileName and mimeType will be infered.
  -parameter fileUrl: The fileUrl is a standard url path to a file.
*/
- (nonnull instancetype)initWithFileUrl:(NSURL * _Nonnull)fileUrl;
/**
  Initializes a new Upload object with a data blob.
  -parameter data: The data is a NSData representation of a file’s data.
  -parameter fileName: The fileName is just that. The file’s name.
  -parameter mimeType: The mimeType is just that. The mime type you would like the file to uploaded as.
  upload a file from a a data blob. Must add a filename and mimeType as that can’t be infered from the data
*/
- (nonnull instancetype)initWithData:(NSData * _Nonnull)data fileName:(NSString * _Nonnull)fileName mimeType:(NSString * _Nonnull)mimeType;
@end


@interface Upload (SWIFT_EXTENSION(ETILinkSDK))
@end


@interface NSUserDefaults (SWIFT_EXTENSION(ETILinkSDK))
@end

#pragma clang diagnostic pop
