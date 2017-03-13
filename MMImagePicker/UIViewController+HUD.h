//
//  UIViewController+HUD.h
//  MMImagePickerDemo
//
//  Created by LEA on 2017/3/13.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (HUD)

- (void)showHUD:(NSString *)title;
- (void)hideHUD;

@end
