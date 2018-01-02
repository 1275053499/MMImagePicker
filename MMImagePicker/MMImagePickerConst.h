//
//  MMImagePickerConst.h
//  MMImagePickerDemo
//
//  Created by LEA on 2018/1/2.
//  Copyright © 2018年 LEA. All rights reserved.
//

#import "UIView+Geometry.h"
#import "MBProgressHUD.h"

//#### 宏定义
// 6p?
#define kDeviceIsIphone6p               CGSizeEqualToSize(CGSizeMake(1242,2208), [[[UIScreen mainScreen] currentMode] size])
// X?
#define kDeviceIsIphoneX                CGSizeEqualToSize(CGSizeMake(1125,2436), [[[UIScreen mainScreen] currentMode] size])
// 图片边距
#define kBlankWidth                     4.0f
// 底部菜单高度
#define kBottomHeight                   (kDeviceIsIphoneX?64.0f:44.0f)
// 主颜色
#define kMainColor                      [UIColor colorWithRed:26.0/255.0 green:181.0/255.0 blue:237.0/255.0 alpha:1.0]
// 图片路径
#define MMImagePickerSrcName(file)      [@"MMImagePicker.bundle" stringByAppendingPathComponent:file]
// 状态栏高度
#define kStatusHeight                   [[UIApplication sharedApplication] statusBarFrame].size.height
// 导航栏高度
#define kNavHeight                      self.navigationController.navigationBar.height
// 顶部整体高度
#define kTopBarHeight                   ([[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.height)

