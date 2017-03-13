//
//  MMAlbumPickerController.h
//  MMImagePicker
//
//  Created by LEA on 2017/3/2.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "UIViewController+HUD.h"
#import "UIView+Geometry.h"
#import "MMBarButtonItem.h"
#import "MMImagePickerController.h"
#import "MMAlbumCell.h"

@interface MMAlbumPickerController : UIViewController

//主色调[默认蓝色]
@property (nonatomic, strong) UIColor *mainColor;
//是否显示原图选项[默认NO]
@property (nonatomic, assign) BOOL showOriginImageOption;
//最大选择数目[默认9张]
@property (nonatomic, assign) NSInteger maximumNumberOfImage;
//代理
@property (nonatomic, assign) id delegate;

@end

