//
//  MMImagePickerController.h
//  MMImagePicker
//
//  Created by LEA on 2017/3/2.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>

//#### MMALAsset
#pragma mark - MMALAsset

@interface MMALAsset : NSObject

@property (nonatomic,strong) ALAsset *asset;
@property (nonatomic,assign) BOOL isSelected;

@end

//#### MMImagePickerController
@protocol MMImagePickerDelegate;
@interface MMImagePickerController : UIViewController

//所选相册
@property (nonatomic, strong) ALAssetsGroup *assetGroup;
//主色调
@property (nonatomic, strong) UIColor *mainColor;
//最大选择数目
@property (nonatomic, assign) NSInteger maximumNumberOfImage;
//代理
@property (nonatomic, assign) id<MMImagePickerDelegate> delegate;

@end

@protocol MMImagePickerDelegate <NSObject>

@optional
- (void)mmImagePickerController:(MMImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)mmImagePickerControllerDidCancel:(MMImagePickerController *)picker;

@end
