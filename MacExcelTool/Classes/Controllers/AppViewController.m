//
//  AppViewController.m
//
//  Created by dyf on 16/6/6.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import "AppViewController.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do view setup here.
}

- (void)hideApp:(id)sender
{
	[[NSApplication sharedApplication] hide:sender];
}

- (void)terminateApp:(id)sender
{
	[[NSApplication sharedApplication] terminate:sender];
}

- (BOOL)forceResignFirstResponder {
	return [[NSApplication sharedApplication].keyWindow makeFirstResponder:nil];
}

- (NSWindow *)window {
	return self.view.window;
}

@end
