//
//  AppUtils.m
//
//  Created by dyf on 16/6/7.
//  Copyright © 2016年 dyf. All rights reserved.
//

#import "AppUtils.h"

@interface AppUtils ()

@property (nonatomic, copy) AppGetCertsResponseBlock getCertsHandler;

@end

@implementation AppUtils

- (void)openFinder:(BOOL)canChooseFiles chooseDirectories:(BOOL)canChooseDirectories allowedFileTypes:(NSArray<NSString *> *)fileTypes completionHandler:(AppChooseResponseBlock)handler {
    [self openFinder:canChooseFiles chooseDirectories:canChooseDirectories canCreateDirectories:NO allowedFileTypes:fileTypes completionHandler:handler];
}

- (void)openFinder:(BOOL)canChooseFiles chooseDirectories:(BOOL)canChooseDirectories canCreateDirectories:(BOOL)canCreateDirectories allowedFileTypes:(NSArray<NSString *> *)fileTypes completionHandler:(AppChooseResponseBlock)handler {
    NSOpenPanel *openDlg = [[NSOpenPanel alloc] init];
    [openDlg setCanChooseFiles:canChooseFiles];
    [openDlg setCanChooseDirectories:canChooseDirectories];
    [openDlg setCanCreateDirectories:canCreateDirectories];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setAllowsOtherFileTypes:NO];
    [openDlg setAllowedFileTypes:fileTypes];
    if ([openDlg runModal] == NSModalResponseOK) {
        if (handler) {
            handler([[[openDlg URLs] objectAtIndex:0] path]);
        }
    }
}

+ (NSAlert *)showAlert:(NSWindow *)window style:(NSAlertStyle)style title:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles completionHandler:(void (^)(NSInteger))handler {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:style];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    for (NSString *buttonTitle in buttonTitles) {
        [alert addButtonWithTitle:buttonTitle];
    }
    if (window) {
        [alert beginSheetModalForWindow:window completionHandler:^(NSModalResponse returnCode) {
            if (handler) {
                handler(returnCode);
            }
        }];
    } else {
        NSInteger returnCode = [alert runModal];
        if (handler) {
            handler(returnCode);
        }
    }
    return alert;
}

+ (void)localStore:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)localRead:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setTextColorForButton:(NSButton *)button color:(NSColor *)color {
    @autoreleasepool {
        NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[button attributedTitle]];
        NSUInteger len = [attrTitle length];
        NSRange range = NSMakeRange(0, len);
        [attrTitle addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attrTitle fixAttributesInRange:range];
        [button setAttributedTitle:attrTitle];
        [button setNeedsDisplay:YES];
    }
}

@end
