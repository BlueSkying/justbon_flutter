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
//            result([FlutterError errorWithCode:[VpnPlug sharedInstance].status message:@"连接成功" details:nil]);
            
            dispatch_async(dispatch_get_main_queue(), ^{            [self sendmessage];
            });
        }else if ([@"disconnect" isEqualToString:call.method]){
            [[VpnPlug sharedInstance]disconnect];
//            result([FlutterError errorWithCode:[VpnPlug sharedInstance].status message:@"断开连接" details:nil]);
        }
    }];
    
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)sendmessage{
    FlutterBasicMessageChannel * messageChannel = [FlutterBasicMessageChannel messageChannelWithName:@"samples.flutter.io/vpn" binaryMessenger:controller codec:[FlutterStandardMessageCodec sharedInstance]];
    [messageChannel sendMessage:@"新标题" reply:^(id  _Nullable reply) {
        NSLog(@"reply ==%@",reply);
    }];
    [messageChannel setMessageHandler:^(id  _Nullable message, FlutterReply  _Nonnull callback) {
        NSString * mess = (NSString *)message;
        if (mess.length > 0){
          NSLog(@"dart发送过来的消息==%@",message);
          callback(@"ios回传");
        }
    }];
}

@end
