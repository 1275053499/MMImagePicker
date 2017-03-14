//
//  MMImagePickerController.m
//  MMImagePicker
//
//  Created by LEA on 2017/3/2.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "MMImagePickerController.h"
#import "MMImagePreviewController.h"
#import "UIViewController+HUD.h"
#import "MMBarButtonItem.h"
#import "UIView+Geometry.h"
#import "MMAssetCell.h"

//#### 宏定义
#define kDeviceIsIphone4        CGSizeEqualToSize(CGSizeMake(640,960), [[[UIScreen mainScreen] currentMode] size])
#define kDeviceIsIphone5        CGSizeEqualToSize(CGSizeMake(640,1136), [[[UIScreen mainScreen] currentMode] size])
#define kDeviceIsIphone6        CGSizeEqualToSize(CGSizeMake(750,1334), [[[UIScreen mainScreen] currentMode] size])
#define kDeviceIsIphone6p       CGSizeEqualToSize(CGSizeMake(1242,2208), [[[UIScreen mainScreen] currentMode] size])
#define kBlankWidth             4.0f
#define kBottomHeight           44.0f
#define RGBColor(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kMainColor              RGBColor(26, 181, 237, 1.0)

//#### MMALAsset
@implementation MMALAsset

@end

//##### MMPhotoAlbumSelector
static NSString *const CellIdentifier = @"MMPhotoAlbumCell";

@interface MMImagePickerController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) ALAssetsLibrary *library;
@property (nonatomic,strong) UICollectionView *collectionView;
//@[MMAlsset,MMAlsset...]
@property (nonatomic,strong) NSMutableArray *mmAssetArray;
//@[Alsset,Alsset...]
@property (nonatomic,strong) NSMutableArray *selectedAssetArray;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *previewBtn;
@property (nonatomic,strong) UIButton *originBtn;
@property (nonatomic,strong) UIButton *finishBtn;
@property (nonatomic,strong) UILabel *numberLab;

@end

@implementation MMImagePickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选取照片";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[MMBarButtonItem alloc] initWithTitle:@"取消" target:self action:@selector(rightBarItemAction)];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers count] > 1) {
        self.navigationItem.leftBarButtonItem = [[MMBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mmphoto_back"] target:self action:@selector(leftBarItemAction)];
    }

    _isOrigin = NO;
    if (!_mainColor) {
        _mainColor = kMainColor;
    }
    if (_maximumNumberOfImage == 0) {
        _maximumNumberOfImage = 9;
    }
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomView];
    [self getPhotoAlbum];
    
    //是否显示原图选项
    _originBtn.hidden = !self.showOriginImageOption;
}

#pragma mark - 获取照片刷新瀑布流
- (void)getPhotoAlbum
{
    //## 已选相册
    if (self.assetGroup) {
        [self getPhotos];
        return;
    }
    
    //## 未选择相册
    //1.获取系统相册列表
    self.library = [[ALAssetsLibrary alloc] init];
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (!group) {
            return ;
        }
        //2.剔除空相册
        NSInteger count = [group numberOfAssets];
        if (count) {
            NSString *groupPropertyName = [group valueForProperty:ALAssetsGroupPropertyName];
            NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
            if ([[groupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                self.assetGroup = group;
            }
            //3.获取该相册照片
            [self getPhotos];
        }
    } failureBlock:^(NSError *error) {
        //## 无权限提示
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

- (void)getPhotos
{
    [self showHUD:@"图片加载中"];
    self.mmAssetArray = [[NSMutableArray alloc] init];
    self.selectedAssetArray = [[NSMutableArray alloc] init];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
         {
             if (!result) {
                 return;
             }
             //只处理图片[忽略视频]
             if([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto])
             {
                 MMALAsset *mmAsset = [[MMALAsset alloc] init];
                 mmAsset.asset = result;
                 mmAsset.isSelected = NO;
                 [self.mmAssetArray addObject:mmAsset];
             }
         }];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [self hideHUD];
        });
    });
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-kBottomHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[MMAssetCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.collectionView.bottom, self.view.width, kBottomHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.userInteractionEnabled = NO;
        _bottomView.alpha = 0.5;
        
        //上边框
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, _bottomView.width, 0.5);
        layer.backgroundColor = [[UIColor lightGrayColor] CGColor];
        [_bottomView.layer addSublayer:layer];
        
        //子视图
        _previewBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, kBottomHeight, kBottomHeight)];
        _previewBtn.tag = 100;
        [_previewBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_previewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_previewBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_previewBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_previewBtn];
        
        _originBtn = [[UIButton alloc] initWithFrame:CGRectMake(_previewBtn.right+10, 0, 80, kBottomHeight)];
        _originBtn.tag = 101;
        [_originBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_originBtn setTitle:@"原图" forState:UIControlStateNormal];
        [_originBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_originBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 0, 12, 60)];
        [_originBtn setImage:[UIImage imageNamed:@"mmphoto_mark"] forState:UIControlStateNormal];
        [_originBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_originBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_originBtn];
        
        _numberLab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-70, (kBottomHeight-20)/2, 20, 20)];
        _numberLab.backgroundColor = _mainColor;
        _numberLab.layer.cornerRadius = _numberLab.frame.size.height/2;
        _numberLab.layer.masksToBounds = YES;
        _numberLab.textColor = [UIColor whiteColor];
        _numberLab.textAlignment = NSTextAlignmentCenter;
        _numberLab.font = [UIFont boldSystemFontOfSize:13.0];
        _numberLab.adjustsFontSizeToFitWidth = YES;
        [_bottomView addSubview:_numberLab];
        _numberLab.hidden = YES;
        
        _finishBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-60, 0, 60, kBottomHeight)];
        _finishBtn.tag = 102;
        [_finishBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_finishBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_finishBtn setTitleColor:_mainColor forState:UIControlStateNormal];
        [_finishBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_finishBtn];
    }
    return _bottomView;
}

#pragma mark - 事件处理
- (void)rightBarItemAction
{
    if ([self.delegate respondsToSelector:@selector(mmImagePickerControllerDidCancel:)]) {
        [self.delegate mmImagePickerControllerDidCancel:self];
    }
}

- (void)leftBarItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonAction:(UIButton *)btn
{
    if (btn.tag == 100) //预览
    {
        MMImagePreviewController *previewVC = [[MMImagePreviewController alloc] init];
        previewVC.assetArray = self.selectedAssetArray;
        [previewVC setPhotoDeleteBlock:^(ALAsset *asset)
         {
             for (MMALAsset *mmAsset in self.mmAssetArray) {
                 if (mmAsset.asset == asset)  {
                     NSInteger index = [self.mmAssetArray indexOfObject:mmAsset];
                     mmAsset.isSelected = NO;
                     [self.mmAssetArray replaceObjectAtIndex:index withObject:mmAsset];
                     [self.collectionView reloadData];
                     break;
                 }
             }
             [self updateUI];
         }];
        [self.navigationController pushViewController:previewVC animated:YES];
    }
    else if (btn.tag == 101)  //原图
    {
        if (_isOrigin) {
            [_originBtn setImage:[UIImage imageNamed:@"mmphoto_mark"] forState:UIControlStateNormal];
        } else {
            [_originBtn setImage:[UIImage imageNamed:@"mmphoto_marked"] forState:UIControlStateNormal];
        }
        _isOrigin = !_isOrigin;
    }
    else //确定
    {
        if (![self.delegate respondsToSelector:@selector(mmImagePickerController:didFinishPickingMediaWithInfo:)]) {
            NSLog(@"警告:未设置代理方法!!!");
            return;
        }
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for(ALAsset *asset in self.selectedAssetArray)
        {
            id obj = [asset valueForProperty:ALAssetPropertyType];
            if (!obj) {
                continue;
            }
            
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
            if (location) {
                [dictionary setObject:location forKey:ALAssetPropertyLocation];
            }
            [dictionary setObject:obj forKey:UIImagePickerControllerMediaType];
            ALAssetRepresentation *assetRep = [asset defaultRepresentation];
            if(assetRep != nil)
            {
                CGImageRef imgRef = [assetRep fullScreenImage];
                UIImageOrientation orientation = UIImageOrientationUp;
                UIImage *image = [UIImage imageWithCGImage:imgRef scale:1.0f orientation:orientation];
                [dictionary setObject:image forKey:UIImagePickerControllerOriginalImage];
                [dictionary setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:UIImagePickerControllerReferenceURL];
                [result addObject:dictionary];
            }
        }
        [self.delegate mmImagePickerController:self didFinishPickingMediaWithInfo:result];
    }
}

- (void)updateUI
{
    if (![self.selectedAssetArray count]) {
        self.bottomView.alpha = 0.5;
        _numberLab.hidden = YES;
        self.bottomView.userInteractionEnabled = NO;
    } else {
        self.bottomView.alpha = 1.0;
        _numberLab.hidden = NO;
        _numberLab.text = [NSString stringWithFormat:@"%d",(int)[self.selectedAssetArray count]];
        self.bottomView.userInteractionEnabled = YES;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSInteger eachLine = 4;
    if (kDeviceIsIphone6p) {
        eachLine = 5;
    }
    CGFloat cellWidth = (self.view.width-(eachLine+1)*kBlankWidth)/eachLine;
    return CGSizeMake(cellWidth, cellWidth);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kBlankWidth, kBlankWidth, kBlankWidth, kBlankWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kBlankWidth;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.mmAssetArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMALAsset *asset = [self.mmAssetArray objectAtIndex:indexPath.row];
    MMAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
    cell.selected = asset.isSelected;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    MMALAsset *asset = [self.mmAssetArray objectAtIndex:indexPath.row];
    if (([self.selectedAssetArray count] == _maximumNumberOfImage) && !asset.isSelected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"您最多可以添加%ld张图片！",(long)_maximumNumberOfImage]
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    asset.isSelected = !asset.isSelected;
    [self.mmAssetArray replaceObjectAtIndex:indexPath.row withObject:asset];
    [self.collectionView reloadData];
    
    if (asset.isSelected) {
        [self.selectedAssetArray addObject:asset.asset];
    } else {
        [self.selectedAssetArray removeObject:asset.asset];
    }
    
    [self updateUI];
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
