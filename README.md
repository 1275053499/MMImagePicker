#MMImagePicker

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/dexianyinjiu/MMImagePicker/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/MMImagePicker.svg?style=flat)](http://cocoapods.org/?q=MMImagePicker)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/MMImagePicker.svg?style=flat)](http://cocoapods.org/?q=MMImagePicker)&nbsp;

![MMImagePicker](MMImagePicker.gif)

##使用

####方式一：
1. `pod 'MMImagePicker', '~> 1.2'`;
2. `pod install` / `pod update`;
3. `#import <MMImagePicker/MMAlbumPickerController.h>`.

####方式二：

1. 下载`MMImagePicker`文件夹，添加到自己的项目中；
2. `#import "MMAlbumPickerController.h"`.

具体使用，参考如下：

```objc
MMAlbumPickerController *mmVC = [[MMAlbumPickerController alloc] init];
mmVC.delegate = self; //代理
mmVC.mainColor = [UIColor blueColor]; //主色调
mmVC.maximumNumberOfImage = 9; //最大选择数目

UINavigationController *mmNav = [[UINavigationController alloc] initWithRootViewController:mmVC];
[mmNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"default_bar"] forBarMetrics:UIBarMetricsDefault];
mmNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
mmNav.navigationBar.tintColor = [UIColor whiteColor];
[self.navigationController presentViewController:mmNav animated:YES completion:nil];
```

代理：

```objc
#pragma mark - 代理
- (void)mmImagePickerController:(MMImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
     NSLog(@"%@",info);
}

 - (void)mmImagePickerControllerDidCancel:(MMImagePickerController *)picker
{
     NSLog(@"取消");
}
```
##要求
`iOS 7.0+ `
`Xcode 7.0+`.

