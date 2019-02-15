//
//  VpnPlug.m
//  Runner
//
//  Created by huangchen on 2019/2/14.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import "VpnPlug.h"

@implementation VpnPlug

static VpnPlug *instance = nil;

+ (VpnPlug *) sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if (instance == nil){
            instance = [[VpnPlug alloc]init];
        }
    });
    return instance;
}



- (void) connecting:(NSDictionary *)dict{
    if (self.manage){
        [self connect];
        return;
    }
    _status = @"0";
    self.manage = [NEVPNManager sharedManager];
    [self.manage loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        NSError *errors = error;
        if (errors) {
            NSLog(@"%@",errors);
        } else{
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
            //vpn显示的名字
            self.manage.localizedDescription = dict[@"username"];
            
            self.manage.enabled = true;
            __weak __typeof__(self)weakSelf=self;
            [self.manage saveToPreferencesWithCompletionHandler:^(NSError *error) {
                if(error) {
                    NSLog(@"Save error: %@", error);
                } else {
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

- (void) disconnect{
     [self.manage.connection stopVPNTunnel];
}

- (void) deleteVpn{
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        if(managers.count == 0){
            return ;
        }else{
            for (NETunnelProviderManager * manage in managers){
                [manage removeFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
                    if (error != nil){
                        NSLog(@"删除失败");
                    }
                }];
            }
        }
    }];
}

- (void) onVpnStateChange:(NSNotification *)Notification{
    
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
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events {
   //arguments flutter给native的参数
   //回调给flutter，建议使用实例指向，因为该block可以使用多次
    if (events){
        events(@"新标题");
        /*
        NSMutableDictionary * params = [NSMutableDictionary dictionaryWithCapacity:0];
        [params setValue:_status forKey:@"code"];
        [params setValue:@"连接信息" forKey:@"message"];
        [params setValue:@"无信息" forKey:@"details"];
        
        events([self convertToJsonData:params]);
         */
    }
    return nil;
}//此处的arguments可以转化为刚才receiveBroadcastStream("init")的名称，这样我们就可以一个event来监听多个方法实例
//flutter不再接受
- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
   //arguments  flutter给native的参数
    NSLog(@"argument==%@",arguments);
    return nil;
}


-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //    NSRange range = {0,jsonString.length};
    //    //去掉字符串中的空格
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
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

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
