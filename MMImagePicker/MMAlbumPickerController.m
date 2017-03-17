//
//  MMAlbumPickerController.m
//  MMImagePicker
//
//  Created by LEA on 2017/3/2.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMAlbumPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIViewController+HUD.h"
#import "UIView+Geometry.h"
#import "MMBarButtonItem.h"
#import "MMImagePickerController.h"
#import "MMAlbumCell.h"

@interface MMAlbumPickerController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *assetGroups;
@property (strong, nonatomic) ALAssetsLibrary *library;

@end

@implementation MMAlbumPickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"照片";
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = [[MMBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(barButtonItemAction:)];
    [self.view addSubview:self.tableView];
    
    self.assetGroups = [[NSMutableArray alloc] init];
    
    //获取系统相册列表
    [self showHUD:@"列表加载中"];
    self.library = [[ALAssetsLibrary alloc] init];
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        //为空时，枚举完成
        if (!group) {
            [self.tableView reloadData];
            [self hideHUD];
            return ;
        }
        //剔除空相册
        NSInteger count = [group numberOfAssets];
        if (count) {
            NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            if (nType == ALAssetsGroupSavedPhotos) {
                [self.assetGroups insertObject:group atIndex:0];
            } else {
                [self.assetGroups addObject:group];
            }
        }
    } failureBlock:^(NSError *error) {
        [self hideHUD];
        //无权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied){
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"请为开启相册访问权限"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"确定",nil];
            [alterView show];
        }
    }];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.0f;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

#pragma mark - 取消
- (void)barButtonItemAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.assetGroups count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MMAlbumCell";
    MMAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    ALAssetsGroup *assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    NSString *groupPropertyName = [assetGroup valueForProperty:ALAssetsGroupPropertyName];
    NSUInteger nType = [[assetGroup valueForProperty:ALAssetsGroupPropertyType] intValue];
    if (nType == ALAssetsGroupSavedPhotos) {
        groupPropertyName = @"相机胶卷";
    }
    NSInteger count = [assetGroup numberOfAssets];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",groupPropertyName, (long)count];
    cell.imageView.image = [UIImage imageWithCGImage:[assetGroup posterImage]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MMImagePickerController *imagePicker = [[MMImagePickerController alloc] init];
    imagePicker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    imagePicker.delegate = self.delegate;
    imagePicker.mainColor = self.mainColor;
    imagePicker.maximumNumberOfImage = self.maximumNumberOfImage;
    imagePicker.showOriginImageOption = self.showOriginImageOption;
    [self.navigationController pushViewController:imagePicker animated:YES];
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
