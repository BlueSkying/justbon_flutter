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
    NSString *channelName = @"flutter_vpn";
    vpnChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:controller];
    [vpnChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //根据方法名去实现方法
        if([@"prepare" isEqualToString:call.method]){
           
        }else if([@"connect" isEqualToString:call.method]){
            NSDictionary * dict = call.arguments;
            [[VpnPlug sharedInstance] connecting:dict];
            
        }else if ([@"disconnect" isEqualToString:call.method]){
            [[VpnPlug sharedInstance] disconnect];
        }
    }];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)sendmessage:(NSString *)message{
    [vpnChannel invokeMethod:@"vpnStatusChanged" arguments:[VpnPlug sharedInstance].status];
}

@end
