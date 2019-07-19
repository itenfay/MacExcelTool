//
//  FileConvertViewController.m
//
//  Created by dyf on 16/6/6.
//  Copyright © 2016年 dyf. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "FileConvertViewController.h"
#import "AppConstants.h"
#import "AppUtils.h"
#import "AYProgressIndicator.h"

typedef NS_ENUM(NSUInteger, FileConvertType) {
    FileConvertTypeTxt,
    FileConvertTypeExcel,
};

@interface FileConvertViewController ()
@property (weak) IBOutlet NSTextField *tf_txtDirpath;
@property (weak) IBOutlet NSTextField *tf_xlsxOutputPath;
@property (weak) IBOutlet NSTextField *tf_xlsxDirpath;
@property (weak) IBOutlet NSTextField *tf_txtOutputPath;

@property (weak) IBOutlet NSButton *selectTxtDirButton;
@property (weak) IBOutlet NSButton *selectXlsxOutputDirButton;
@property (weak) IBOutlet NSButton *txtToXlsxButton;
@property (weak) IBOutlet NSButton *selectXlsxDirButton;
@property (weak) IBOutlet NSButton *selectTxtOutputDirButton;
@property (weak) IBOutlet NSButton *xlsxToTxtButton;

@property (weak) IBOutlet AYProgressIndicator *progressIndicator;

@property (assign) FileConvertType fcType;

@property (strong) NSArray *fileArray;

@property (assign) double progressValue;
@end

@implementation FileConvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self setupProgressIndicator];
    [self loadHistoricRecords];
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [self forceResignFirstResponder];
}

- (void)setupProgressIndicator {
    self.progressIndicator.maxValue      = 1.0;
    self.progressIndicator.minValue      = 0.0;
    self.progressIndicator.doubleValue   = 0.0;
    self.progressIndicator.emptyColor    = [NSColor whiteColor];
    self.progressIndicator.progressColor = [NSColor greenColor];
}

- (void)conversionBeginning {
    self.selectTxtDirButton.enabled        = NO;
    self.selectXlsxOutputDirButton.enabled = NO;
    self.txtToXlsxButton.enabled           = NO;
    self.selectXlsxDirButton.enabled       = NO;
    self.selectTxtOutputDirButton.enabled  = NO;
    self.xlsxToTxtButton.enabled           = NO;
}

- (void)conversionEnding {
    self.selectTxtDirButton.enabled        = YES;
    self.selectXlsxOutputDirButton.enabled = YES;
    self.txtToXlsxButton.enabled           = YES;
    self.selectXlsxDirButton.enabled       = YES;
    self.selectTxtOutputDirButton.enabled  = YES;
    self.xlsxToTxtButton.enabled           = YES;
}

- (void)loadHistoricRecords {
    NSString *txtDirpath = [AppUtils localRead:kTxtDirPath];
    if (txtDirpath) {
        self.tf_txtDirpath.stringValue = txtDirpath;
    }
    
    NSString *xlsxOutDirpath = [AppUtils localRead:kXlsxOutputDirPath];
    if (xlsxOutDirpath) {
        self.tf_xlsxOutputPath.stringValue = xlsxOutDirpath;
    }
    
    NSString *xlsxDirpath = [AppUtils localRead:kXlsxDirPath];
    if (xlsxDirpath) {
        self.tf_xlsxDirpath.stringValue = xlsxDirpath;
    }
    
    NSString *txtOutDirpath = [AppUtils localRead:kTxtOutputDirPath];
    if (txtOutDirpath) {
        self.tf_txtOutputPath.stringValue = txtOutDirpath;
    }
}

- (BOOL)validateTextFieldStringValue {
    BOOL result = NO;
    
    if (self.fcType == FileConvertTypeExcel) {
        result = self.tf_txtDirpath.stringValue.length > 0 ? YES : NO;
        if (!result) {
            [self alertUser:@"提示" message:@"请选择被转换的txt目录"];
            return NO;
        }
        
        result = self.tf_xlsxOutputPath.stringValue.length > 0 ? YES : NO;
        if (!result) {
            [self alertUser:@"提示" message:@"请选择输出excel的目录"];
            return NO;
        }
    } else if (self.fcType == FileConvertTypeTxt) {
        result = self.tf_xlsxDirpath.stringValue.length > 0 ? YES : NO;
        if (!result) {
            [self alertUser:@"提示" message:@"请选择被转换的excel目录"];
            return NO;
        }
        
        result = self.tf_txtOutputPath.stringValue.length > 0 ? YES : NO;
        if (!result) {
            [self alertUser:@"提示" message:@"请选择输出txt的目录"];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)validatePathExists {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (self.fcType == FileConvertTypeExcel) {
        NSString *projPath = self.tf_txtDirpath.stringValue;
        if (![fileMgr fileExistsAtPath:projPath]) {
            [self alertUser:@"提示" message:@"txt目录不存在"];
            return NO;
        }
        
        NSString *outPath = self.tf_xlsxOutputPath.stringValue;
        if (![fileMgr fileExistsAtPath:outPath]) {
            [self alertUser:@"提示" message:@"excel输出目录不存在"];
            return NO;
        }
    } else if (self.fcType == FileConvertTypeTxt) {
        NSString *cfgFilePath = self.tf_xlsxDirpath.stringValue;
        if (![fileMgr fileExistsAtPath:cfgFilePath]) {
            [self alertUser:@"提示" message:@"excel目录不存在"];
            return NO;
        }
        
        NSString *sdksPath = self.tf_txtOutputPath.stringValue;
        if (![fileMgr fileExistsAtPath:sdksPath]) {
            [self alertUser:@"提示" message:@"txt输出目录不存在"];
            return NO;
        }
    }
    
    return YES;
}

- (IBAction)selectTxtDirectory:(id)sender {
    AppUtils *utils = [[AppUtils alloc] init];
    [utils openFinder:NO chooseDirectories:YES canCreateDirectories:YES allowedFileTypes:nil completionHandler:^(NSString *path) {
        if (path) {
            [self.tf_txtDirpath setStringValue:path];
            [AppUtils localStore:path forKey:kTxtDirPath];
        }
    }];
}

- (IBAction)selectXlsxOutputDirectory:(id)sender {
    AppUtils *utils = [[AppUtils alloc] init];
    [utils openFinder:NO chooseDirectories:YES canCreateDirectories:YES allowedFileTypes:nil completionHandler:^(NSString *path) {
        if (path) {
            [self.tf_xlsxOutputPath setStringValue:path];
            [AppUtils localStore:path forKey:kXlsxOutputDirPath];
        }
    }];
}

- (IBAction)convertTxtToExcel:(id)sender {
    [self startConverting:FileConvertTypeExcel];
}

- (IBAction)selectXlsxDirectory:(id)sender {
    AppUtils *utils = [[AppUtils alloc] init];
    [utils openFinder:NO chooseDirectories:YES canCreateDirectories:YES allowedFileTypes:nil completionHandler:^(NSString *path) {
        if (path) {
            [self.tf_xlsxDirpath setStringValue:path];
            [AppUtils localStore:path forKey:kXlsxDirPath];
        }
    }];
}

- (IBAction)selectTxtOutputDirectory:(id)sender {
    AppUtils *utils = [[AppUtils alloc] init];
    [utils openFinder:NO chooseDirectories:YES canCreateDirectories:YES allowedFileTypes:nil completionHandler:^(NSString *path) {
        if (path) {
            [self.tf_txtOutputPath setStringValue:path];
            [AppUtils localStore:path forKey:kTxtOutputDirPath];
        }
    }];
}

- (IBAction)convertExcelToTxt:(id)sender {
    [self startConverting:FileConvertTypeTxt];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [self forceResignFirstResponder];
}

- (void)alertUser:(NSString *)title message:(NSString *)message {
    [AppUtils showAlert:self.window style:NSInformationalAlertStyle title:title message:message buttonTitles:@[@"好的"] completionHandler:nil];
}

- (void)predictScheduleScale {
    self.progressValue = 1.0/self.fileArray.count;
}

- (void)startConverting:(FileConvertType)type {
    [self forceResignFirstResponder];
    self.fcType = type;
    if ([self validateTextFieldStringValue] && [self validatePathExists]) {
        [self conversionBeginning];
        if ([self loadLocalFilePaths]) {
            [self predictScheduleScale];
            [self next:0];
        }
    }
}

- (IBAction)minimizeAction:(id)sender {
    [self hideApp:sender];
}

- (IBAction)closeAction:(id)sender {
    [AppUtils showAlert:self.window style:NSInformationalAlertStyle title:@"温馨提示" message:@"确定退出应用吗？" buttonTitles:@[@"退出", @"取消"] completionHandler:^(NSInteger returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            [self terminateApp:sender];
        }
    }];
}

- (BOOL)loadLocalFilePaths {
    NSMutableArray *m_arr = [NSMutableArray arrayWithCapacity:0];
    
    NSString *path = (self.fcType == FileConvertTypeExcel) ? self.tf_txtDirpath.stringValue : self.tf_xlsxDirpath.stringValue;
    NSString *srcExt = (self.fcType == FileConvertTypeExcel) ? @"txt" : @"xlsx";
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSArray *items = [fileMgr contentsOfDirectoryAtPath:path error:nil];
    for (NSInteger i = 0; i < items.count; i++) {
        NSString *name = [items objectAtIndex:i];
        if (![name hasSuffix:srcExt]) {
            continue;
        }
        NSString *filepath = [path stringByAppendingPathComponent:name];
        [m_arr addObject:filepath];
    }
    
    self.fileArray = [m_arr copy];
    
    return YES;
}

- (void)updateEnvironmentForTask:(NSTask *)task {
    NSMutableDictionary *env = [NSMutableDictionary dictionaryWithDictionary:task.environment];
    [env removeObjectForKey:kMallocNanoZone];
    [task setEnvironment:env];
}

- (void)fileHandleReadObserver:(NSPipe *)pipe {
    NSFileHandle *fileHandle = [pipe fileHandleForReading];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileHandleReadCompleted:) name:NSFileHandleReadToEndOfFileCompletionNotification object:fileHandle];
    [fileHandle readToEndOfFileInBackgroundAndNotify];
}

- (NSString *)vectorDirectoryPath {
    return [[NSBundle mainBundle] pathForResource:APVectorDirname ofType:nil];
}

- (NSString *)binDirectoryPath {
    return [[self vectorDirectoryPath] stringByAppendingPathComponent:APCmdLocDirpath];
}

- (NSString *)taskLaunchPath {
    return [[self binDirectoryPath] stringByAppendingPathComponent:APCmdName];
}

- (void)launch:(NSString *)launchPath arguments:(NSArray *)args index:(NSInteger)index {
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:launchPath];
    [task setArguments:args];
    
    [self updateEnvironmentForTask:task];
    [self scheduledTimerForCheckingTask:task index:index];
    
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput:pipe];
    [task setStandardError:pipe];
    [self fileHandleReadObserver:pipe];
    
    [task launch];
}

- (void)scheduledTimerForCheckingTask:(NSTask *)task index:(NSInteger)index {
    NSDictionary *dict = @{@"Task": task, @"Index": @(index)};
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkTask:) userInfo:dict repeats:YES];
}

- (void)fileHandleReadCompleted:(NSNotification *)noti {
    NSData *data =[[noti userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    DBLog(@"FileHandleReadToEndOfFileCompletion msg: %@", msg);
    //NSString *filename = [NSString stringWithFormat:@"fclog.data"];
    //[self writeToFile:filename errorLog:data];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadToEndOfFileCompletionNotification object:[noti object]];
}

- (void)writeToFile:(NSString *)filename errorLog:(NSData *)errorLog {
    NSString *dirpath = (self.fcType == FileConvertTypeExcel) ? self.tf_xlsxOutputPath.stringValue : self.tf_txtOutputPath.stringValue;
    NSString *filepath = [dirpath stringByAppendingPathComponent:filename];
    DBLog(@"filepath: %@", filepath);
    [errorLog writeToFile:filepath atomically:YES];
}

- (void)checkTask:(NSTimer *)timer {
    NSDictionary *dict = (NSDictionary *)timer.userInfo;
    NSTask *task = [dict objectForKey:@"Task"];
    if (![task isRunning]) {
        [self invalidateTimer:timer];
        NSInteger idx = [[dict objectForKey:@"Index"] integerValue];
        [self next:++idx];
    }
}

- (void)updateProgress {
    if (self.progressIndicator && self.progressIndicator.doubleValue <= 0.98) {
        self.progressIndicator.doubleValue += self.progressValue;
        [self.progressIndicator display];
    }
}

- (void)invalidateTimer:(NSTimer *)timer {
    [timer invalidate];
    timer = nil;
}

- (void)completeProgress {
    self.progressIndicator.doubleValue = 1.0;
}

- (void)resetProgress {
    self.progressIndicator.doubleValue = 0.0;
}

- (void)next:(NSInteger)index {
    if (index < self.fileArray.count) {
        DBLog(@"index: %zi", index);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateProgress];
        });
        
        NSString *launchPath = [self taskLaunchPath];
        
        NSString *type = (self.fcType == FileConvertTypeExcel) ? @"xlsx" : @"txt";
        NSString *srcpath = [self.fileArray objectAtIndex:index];
        NSString *dstpath = (self.fcType == FileConvertTypeExcel) ? self.tf_xlsxOutputPath.stringValue : self.tf_txtOutputPath.stringValue;
        
        NSMutableArray *args = [NSMutableArray arrayWithCapacity:0];
        [args addObject:type];
        [args addObject:srcpath];
        [args addObject:dstpath];
        
        [self launch:launchPath arguments:args index:index];
    } else {
        [self completeProgress];
        [self showCompletionTips];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self conversionEnding];
            [self resetProgress];
            [self setFileArray:nil];
        });
    }
}

- (void)showCompletionTips {
    [AppUtils showAlert:self.window style:NSInformationalAlertStyle title:@"温馨提示" message:@"文件已全部完成转换" buttonTitles:@[@"前往", @"取消"] completionHandler:^(NSInteger returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            NSString *dirpath = (self.fcType == FileConvertTypeExcel) ? self.tf_xlsxOutputPath.stringValue : self.tf_txtOutputPath.stringValue;
            [[NSWorkspace sharedWorkspace] openFile:dirpath];
        }
    }];
}

@end
