//
//  AppViewController.h
//
//  Created by dyf on 16/6/6.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppMacros.h"

@interface AppViewController : NSViewController

/**
 *  隐藏App
 *
 *  @param sender 消息触发者
 */
- (void)hideApp:(nullable id)sender;

/**
 *  退出App
 *
 *  @param sender 消息触发者
 */
- (void)terminateApp:(nullable id)sender;

/**
 *  强制注销第一响应
 *
 *  @return bool
 */
- (BOOL)forceResignFirstResponder;

/**
 *  返回视图窗体
 *
 *  @return
 */
- (nullable NSWindow *)window;

@end
