#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <Flutter/Flutter.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    FlutterViewController * controller = (FlutterViewController*)self.window.rootViewController;
    FlutterMethodChannel * vpnChannel = [FlutterMethodChannel methodChannelWithName:@"samples.flutter.io/vpn" binaryMessenger:controller];
    [vpnChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //根据方法名去实现方法
        if([@"perpre" isEqualToString:call.method]){
            [self perpre];
        }else if([@"connect" isEqualToString:call.method]){
            [self connect];
        }else if ([@"disconnect" isEqualToString:call.method]){
            [self disconnect];
        }
    }];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)perpre{
    self.manage = [NEVPNManager sharedManager];
    [self.manage loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        NSError *errors = error;
        if (errors) {
            NSLog(@"%@",errors);
        }
        else{
            NEVPNProtocolIKEv2 *p = [[NEVPNProtocolIKEv2 alloc] init];
            
            //用户名
            p.username = @"vpn77";
            //服务器地址
            p.serverAddress = @"test.3356.cc";
            
            //密码
            [self createKeychainValue:@"a123456" forIdentifier:@"VPN_PASSWORD"];
            p.passwordReference =  [self searchKeychainCopyMatching:@"VPN_PASSWORD"];
            
            //共享秘钥    可以和密码同一个.
            [self createKeychainValue:@"a123456" forIdentifier:@"PSK"];
            p.sharedSecretReference = [self searchKeychainCopyMatching:@"PSK"];
            
            p.localIdentifier = @"test.3356.cc";
            
            p.remoteIdentifier = @"test.3356.cc";
            
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
            self.manage.localizedDescription = @"大番薯";
            
            self.manage.enabled = true;
            
            [self.manage saveToPreferencesWithCompletionHandler:^(NSError *error) {
                if(error) {
                    NSLog(@"Save error: %@", error);
                }
                else {
                    NSLog(@"Saved!");
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

-(void)onVpnStateChange:(NSNotification *)Notification {
    
    NEVPNStatus state = self.manage.connection.status;
    
    switch (state) {
        case NEVPNStatusInvalid:
            NSLog(@"无效连接");
            break;
        case NEVPNStatusDisconnected:
            NSLog(@"未连接");
            break;
        case NEVPNStatusConnecting:
            NSLog(@"正在连接");
            break;
        case NEVPNStatusConnected:
            NSLog(@"已连接");
            break;
        case NEVPNStatusDisconnecting:
            NSLog(@"断开连接");
            break;
        default:
            break;
    }
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
