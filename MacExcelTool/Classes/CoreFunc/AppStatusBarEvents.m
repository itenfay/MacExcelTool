//
//  AppStatusBarEvents.m
//
//  Created by dyf on 16/6/30.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import "AppStatusBarEvents.h"
#import "AppUtil.h"

@implementation AppStatusBarEvents

+ (void)help {
	NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
	NSString *title = [NSString stringWithFormat:@"帮助"];
	NSString *message = [NSString stringWithFormat:@"@Author: %@", infoDict[@"Author"]];
	message = [message stringByAppendingString:@"\n"];
	message = [message stringByAppendingFormat:@"@Email: %@", infoDict[@"Email"]];
	[AppUtil showAlert:nil style:NSWarningAlertStyle title:title message:message buttonTitles:@[@"OK"] completionHandler:nil];
}

@end
