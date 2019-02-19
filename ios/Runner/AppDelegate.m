#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "VpnPlug.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    // 注册方法，当vpn状态发生改变的时候通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendmessage:) name:@"vpnStatusChange" object:nil];
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
            [[VpnPlug sharedInstance] connecting:dict withResult:^(NSString *status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        result([FlutterError errorWithCode:[VpnPlug sharedInstance].status message:@"连接成功" details:nil]);
//                        [weakSelf sendmessage:@"连接成功"];
                    });
            }];
            
        }else if ([@"disconnect" isEqualToString:call.method]){
            [[VpnPlug sharedInstance] disconnectWithResult:^(NSString *status) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        result([FlutterError errorWithCode:[VpnPlug sharedInstance].status message:@"断开成功" details:nil]);
//                        [weakSelf sendmessage:@"断开连接"];
                    });
            }];
        }
    }];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)sendmessage:(NSString *)message{
    [vpnChannel invokeMethod:@"vpnStatusChanged" arguments:[VpnPlug sharedInstance].status];
}

@end
