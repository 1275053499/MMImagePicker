#MMImagePicker

 图片选择器

![MMImagePicker](MMImagePicker.gif)

###使用方式

 下载本demo，将demo中的'MMImagePicker'文件夹，添加到自己的项目，引入头文件和代理，具体使用参考如下：

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

###License
MIT
