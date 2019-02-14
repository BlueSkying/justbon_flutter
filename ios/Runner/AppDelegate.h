#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import <NetworkExtension/NetworkExtension.h>
@interface AppDelegate : FlutterAppDelegate<FlutterStreamHandler>
{
    FlutterViewController * controller;
    FlutterMethodChannel * vpnChannel;
}
@property (nonatomic,strong)NEVPNManager *manage;

@property (nonatomic,assign)NSString * status;
    
@end
