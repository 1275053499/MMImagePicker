//
//  ViewController.m
//  MMImagePickerDemo
//
//  Created by LEA on 2017/3/13.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import "ViewController.h"
#import "MMImagePickerController.h"

static NSString *const CellIdentifier = @"PhotoCell";
@interface ViewController () <MMImagePickerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Demo";
    // 选择图片
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-100)/2, 50, 100, 44)];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"选择图片" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // 图片显示
    self.imageArray = [[NSMutableArray alloc] init];
    [self.view addSubview:self.collectionView];
}

#pragma mark - 选择图片
- (void)btClicked
{
    MMImagePickerController *mmVC = [[MMImagePickerController alloc] init];
    mmVC.delegate = self;
    mmVC.showOriginImageOption = YES;
    mmVC.maximumNumberOfImage = 9;
//    mmVC.cropImageOption = YES;
//    mmVC.singleImageOption = YES;
    UINavigationController *mmNav = [[UINavigationController alloc] initWithRootViewController:mmVC];
    [mmNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"default_bar"] forBarMetrics:UIBarMetricsDefault];
    mmNav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:19.0]};
    mmNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
    mmNav.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController presentViewController:mmNav animated:YES completion:nil];
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 150, self.view.width, self.view.height-kTopBarHeight-150) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

#pragma mark - MMImagePickerDelegate
- (void)mmImagePickerController:(MMImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self.imageArray removeAllObjects];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int i = 0; i < [info count]; i ++)  {
            NSDictionary *dict = [info objectAtIndex:i];
            UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
            if (picker.isOrigin) { //原图
                [self.imageArray addObject:image];
            } else {
                NSData *imageData = UIImageJPEGRepresentation(image,1.0);
                int size = (int)[imageData length]/1024;
                if (size < 100) {
                    imageData = UIImageJPEGRepresentation(image, 0.5);
                } else {
                    imageData = UIImageJPEGRepresentation(image, 0.1);
                }
                image = [UIImage imageWithData:imageData];
                [self.imageArray addObject:image];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [picker dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

- (void)mmImagePickerControllerDidCancel:(MMImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 赋值
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.image = [self.imageArray objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

#pragma mark - ####################  PhotoCell
@interface PhotoCell ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        [self addSubview:self.imageView];
    }
    return self;
}

#pragma mark - getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.layer.masksToBounds = YES;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    }
    return _imageView;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
}

@end
