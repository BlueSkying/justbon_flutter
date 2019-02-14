//
//  VpnPlug.h
//  Runner
//
//  Created by huangchen on 2019/2/14.
//  Copyright © 2019年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NetworkExtension/NetworkExtension.h>
@interface VpnPlug : NSObject

+ (VpnPlug *) sharedInstance;

@property (nonatomic,strong)NEVPNManager *manage;

@property (nonatomic,assign)NSString * status;

- (void) connecting:(NSDictionary *)dict;

- (void) disconnect;

@end
