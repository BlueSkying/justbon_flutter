//
//  VpnPlug.h
//  Runner
//
//  Created by huangchen on 2019/2/14.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>
#import <Flutter/Flutter.h>
@interface VpnPlug : NSObject<FlutterStreamHandler>

+ (VpnPlug *) sharedInstance;

@property (nonatomic,strong)NEVPNManager *manage;

@property (nonatomic,assign)NSString * status;

@property (nonatomic,strong)FlutterEventChannel *eventChannel;

- (void) connecting:(NSDictionary *)dict withResult:(void(^)(NSString * status))result;

- (void) disconnectWithResult:(void(^)(NSString * status))result;

@end
