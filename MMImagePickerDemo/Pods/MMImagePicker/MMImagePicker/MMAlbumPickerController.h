//
//  MMAlbumPickerController.h
//  MMImagePicker
//
//  Created by LEA on 2017/3/2.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIKit.h>
#import "MMImagePickerController.h"
#import "MMBarButtonItem.h"
#import "MMAlbumCell.h"
#import "UIView+Geometry.h"

@interface MMAlbumPickerController : UIViewController

//主色调
@property (nonatomic, strong) UIColor *mainColor;
//最大选择数目
@property (nonatomic, assign) NSInteger maximumNumberOfImage;
//代理
@property (nonatomic, assign) id delegate;

@end

