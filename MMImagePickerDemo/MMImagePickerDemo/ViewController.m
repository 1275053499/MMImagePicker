//
//  ViewController.m
//  MMImagePickerDemo
//
//  Created by LEA on 2017/3/11.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "ViewController.h"
#import <MMImagePicker/MMAlbumPickerController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"DEMO";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-100)/2, 80, 100, 44)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"选择图片" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - 选择图片
- (void)btClicked
{
    MMAlbumPickerController *mmVC = [[MMAlbumPickerController alloc] init];
    mmVC.delegate = self;
    
    UINavigationController *mmNav = [[UINavigationController alloc] initWithRootViewController:mmVC];
    [mmNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"default_bar"] forBarMetrics:UIBarMetricsDefault];
    mmNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    mmNav.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController presentViewController:mmNav animated:YES completion:nil];
}

#pragma mark - 代理
- (void)mmImagePickerController:(MMImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSLog(@"%@",info);
}

- (void)mmImagePickerControllerDidCancel:(MMImagePickerController *)picker
{
    NSLog(@"取消");
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
