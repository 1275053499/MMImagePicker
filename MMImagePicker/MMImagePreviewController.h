//
//  MMImagePreviewController.h
//  MMImagePicker
//
//  Created by LEA on 2017/3/2.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MMImagePreviewController : UIViewController

@property (nonatomic,strong) NSMutableArray *assetArray;
@property (nonatomic, copy) void(^photoDeleteBlock)(ALAsset *asset);

@end
