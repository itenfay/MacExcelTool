//
//  AppDelegate.m
//
//  Created by dyf on 16/5/31.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import "AppDelegate.h"
#import "AppStatusBarEvents.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (IBAction)applicationForHelpEvent:(id)sender {
	[AppStatusBarEvents help];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

@end
