//
//  ViewController.m
//  WeexDemo
//
//  Created by 张新 on 16/9/14.
//  Copyright © 2016年 voidxin. All rights reserved.
//
#import "ViewController.h"
#import <WeexSDK/WXSDKInstance.h>
#import "ImageDownloadder.h"
@interface ViewController ()

@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
@property (nonatomic, assign) CGFloat weexHeight;
@property (nonatomic,strong) UIButton *testBtn;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //
    
    //
    UIButton *testBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 64, 200, 100)];
    [self.view addSubview:testBtn];
    [testBtn setTitle:@"我是原生的按钮哈哈哈" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    testBtn.layer.borderWidth = 1;
    testBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.testBtn = testBtn;
    _weexHeight = self.view.frame.size.height - 64;
    [self.navigationController.navigationBar setHidden:YES];
    [self render];
    
}

- (void)dealloc
{
    [_instance destroyInstance];
}

- (void)render
{
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    CGFloat width = self.view.frame.size.width;
    _instance.frame = CGRectMake(0, CGRectGetMaxY(self.testBtn.frame), width, _weexHeight);
    
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf.weexView);
    };
    _instance.onFailed = ^(NSError *error) {
        NSLog(@"failed %@",error);
    };
    
    _instance.renderFinish = ^(UIView *view) {
        NSLog(@"render finish");
    };
    
    _instance.updateFinish = ^(UIView *view) {
        NSLog(@"update Finish");
    };
    NSString *url = [NSString stringWithFormat:@"file://%@/hehe.js",[NSBundle mainBundle].bundlePath];
    
    [_instance renderWithURL:[NSURL URLWithString:url] options:@{@"bundleUrl":url} data:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
