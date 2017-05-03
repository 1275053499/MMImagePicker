# MMImagePicker

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/dexianyinjiu/MMImagePicker/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/MMImagePicker.svg?style=flat)](http://cocoapods.org/?q=MMImagePicker)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/MMImagePicker.svg?style=flat)](http://cocoapods.org/?q=MMImagePicker)&nbsp;

![MMImagePicker](MMImagePicker.gif)

## CocoaPods

1. `pod 'MMImagePicker', '~> 1.9'`;
2. `pod install` / `pod update`;
3. `#import <MMImagePicker/MMAlbumPickerController.h>`.

For example：

```objc
MMAlbumPickerController *mmVC = [[MMAlbumPickerController alloc] init];
mmVC.delegate = self;   
mmVC.mainColor = [UIColor blueColor];  
mmVC.maximumNumberOfImage = 9; 
mmVC.showOriginImageOption = YES;

UINavigationController *mmNav = [[UINavigationController alloc] initWithRootViewController:mmVC];
[mmNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"default_bar"] forBarMetrics:UIBarMetricsDefault];
mmNav.navigationBar.barStyle = UIBarStyleBlackOpaque;
mmNav.navigationBar.tintColor = [UIColor whiteColor];
[self.navigationController presentViewController:mmNav animated:YES completion:nil];
```
```objc
#pragma mark - MMImagePickerDelegate
- (void)mmImagePickerController:(MMImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
     NSLog(@"%@",info);
}

 - (void)mmImagePickerControllerDidCancel:(MMImagePickerController *)picker
{
     NSLog(@"Cancel");
}
```
## Requirements

This library requires `iOS 7.0+` and `Xcode 7.0+`.


## License

MMImagePicker is provided under the MIT license. See LICENSE file for details.



