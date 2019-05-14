//
//  AppMacros.h
//
//  Created by dyf on 16/6/28.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#ifndef AppMacros_h
#define AppMacros_h

#ifdef DEBUG
	#define DBLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
	#define DBLog(...) {}
#endif

#endif /* AppMacros_h */
