#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "VpnPlug.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    controller = (FlutterViewController*)self.window.rootViewController;
    // 要与main.dart中一致
    NSString *channelName = @"samples.flutter.io/vpn";
    vpnChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:controller];
    [vpnChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        //根据方法名去实现方法
        if([@"prepare" isEqualToString:call.method]){

        }else if([@"connect" isEqualToString:call.method]){
            NSDictionary * dict = call.arguments;
            [[VpnPlug sharedInstance] connecting:dict];
            result([FlutterError errorWithCode:[VpnPlug sharedInstance].status message:@"连接成功" details:nil]);
        }else if ([@"disconnect" isEqualToString:call.method]){
            [[VpnPlug sharedInstance]disconnect];
            result([FlutterError errorWithCode:[VpnPlug sharedInstance].status message:@"断开连接" details:nil]);
        }
    }];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
