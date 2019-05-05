//
//  ViewController.m
//
//  Created by dyf on 16/5/31.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import "ViewController.h"
#import "FileConvertViewController.h"
#import "AppNetworking.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadFileConversionViewController];
}

- (void)loadFileConversionViewController
{
    FileConvertViewController *vc = [[FileConvertViewController alloc] init];
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    // Update the view, if already loaded.
}

@end
