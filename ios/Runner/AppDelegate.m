#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    controller = (FlutterViewController*)self.window.rootViewController;
    // 要与main.dart中一致
    NSString *channelName = @"samples.flutter.io/vpn";
    vpnChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:controller];
    __weak __typeof__(self)weakSelf=self;
    [vpnChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //根据方法名去实现方法
        if([@"prepare" isEqualToString:call.method]){

        }else if([@"connect" isEqualToString:call.method]){
            NSDictionary * dict = call.arguments;
            [weakSelf perpre:dict];
            
            result([FlutterError errorWithCode:[weakSelf onVpnStateChange:nil] message:@"连接成功" details:nil]);
        }else if ([@"disconnect" isEqualToString:call.method]){
            [weakSelf disconnect];
            result([FlutterError errorWithCode:[weakSelf onVpnStateChange:nil] message:@"断开连接" details:nil]);
        }
    }];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)perpre:(NSDictionary *)dict{
    self.manage = [NEVPNManager sharedManager];
    [self.manage loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        NSError *errors = error;
        if (errors) {
            NSLog(@"%@",errors);
        }
        else{
            NEVPNProtocolIKEv2 *p = [[NEVPNProtocolIKEv2 alloc] init];
            //用户名
            p.username = dict[@"username"];
            //服务器地址
            p.serverAddress = dict[@"address"];
            //密码
            [self createKeychainValue:dict[@"password"] forIdentifier:@"VPN_PASSWORD"];
            p.passwordReference =  [self searchKeychainCopyMatching:@"VPN_PASSWORD"];
            //共享秘钥    可以和密码同一个.
            [self createKeychainValue:dict[@"password"] forIdentifier:@"PSK"];
            p.sharedSecretReference = [self searchKeychainCopyMatching:@"PSK"];
            
            p.localIdentifier = dict[@"address"];
            
            p.remoteIdentifier = dict[@"address"];
            
            //这特么是个坑
            //NEVPNIKEAuthenticationMethodCertificate
            //NEVPNIKEAuthenticationMethodSharedSecret
            //            p.authenticationMethod = NEVPNIKEAuthenticationMethodCertificate;
            
            p.useExtendedAuthentication = YES;
            
            p.disconnectOnSleep = NO;
            //            p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
            self.manage.onDemandEnabled = NO;
            
            [self.manage setProtocolConfiguration:p];
            //我们app的描述 叫这个 你随便..
            self.manage.localizedDescription = dict[@"username"];
            
            self.manage.enabled = true;
            __weak __typeof__(self)weakSelf=self;
            [self.manage saveToPreferencesWithCompletionHandler:^(NSError *error) {
                if(error) {
                    NSLog(@"Save error: %@", error);
                }
                else {
                    NSLog(@"Saved!");
                    [weakSelf connect];
                }
            }];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVpnStateChange:) name:NEVPNStatusDidChangeNotification object:nil];
}

- (void)connect{
    NSError *error = nil;
    [self.manage.connection startVPNTunnelAndReturnError:&error];
    if(error) {
        NSLog(@"Start error: %@", error.localizedDescription);
    }else
    {
        NSLog(@"Connection established!");
    }
}

- (void)disconnect{
    [self.manage.connection stopVPNTunnel];
}

-(NSString *)onVpnStateChange:(NSNotification *)Notification {
    
    NEVPNStatus state = self.manage.connection.status;
    
    switch (state) {
        case NEVPNStatusInvalid:
            NSLog(@"无效连接");
            _status = @"0";
            break;
        case NEVPNStatusDisconnected:
            NSLog(@"未连接");
            _status = @"1";
            break;
        case NEVPNStatusConnecting:
            NSLog(@"正在连接");
            _status = @"2";
            break;
        case NEVPNStatusConnected:
            NSLog(@"已连接");
            _status = @"3";
            break;
        case NEVPNStatusReasserting:
            NSLog(@"重新连接");
            _status = @"4";
            break;
        case NEVPNStatusDisconnecting:
            NSLog(@"断开连接");
            _status = @"5";
            break;
        default:
            break;
    }
    
    NSString *channelName = @"samples.flutter.io/vpn";
    FlutterEventChannel *evenChannal = [FlutterEventChannel eventChannelWithName:channelName binaryMessenger:controller];
    // 代理FlutterStreamHandler
    [evenChannal setStreamHandler:self];
    
    return _status;
}

#pragma mark - <FlutterStreamHandler>
    // // 这个onListen是Flutter端开始监听这个channel时的回调，第二个参数 EventSink是用来传数据的载体。
- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events {
    // arguments flutter给native的参数
    // 回调给flutter， 建议使用实例指向，因为该block可以使用多次
    if (events) {
        events(@"push传值给flutter的vc");
    }
    return nil;
}
    /// flutter不再接收
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    // arguments flutter给native的参数
    NSLog(@"%@", arguments);
    return nil;
}
    
- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    CFTypeRef result = NULL;
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    return (__bridge_transfer NSData *)result;
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    // creat a new item
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    //OSStatus 就是一个返回状态的code 不同的类返回的结果不同
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}

//服务器地址
static NSString * const serviceName = @"";

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    //   keychain item creat
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    //   extern CFTypeRef kSecClassGenericPassword  一般密码
    //   extern CFTypeRef kSecClassInternetPassword 网络密码
    //   extern CFTypeRef kSecClassCertificate 证书
    //   extern CFTypeRef kSecClassKey 秘钥
    //   extern CFTypeRef kSecClassIdentity 带秘钥的证书
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    //ksecClass 主键
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    return searchDictionary;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
