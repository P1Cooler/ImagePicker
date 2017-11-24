# ImagePicker
P1ImagePickerController 重构

# P1ImagePickerController重构
# 背景

1、工程中存在3处调用系统图片库，读取视频/图片的位置，分别是头像选择图片（单张视频/图片选择、UIImagePickerController）、朋友圈选择视频（UIImagePickerController）、朋友圈选择图片（读取图片资源，自定义展示）、WebView中调用图片/视频（未发现入口），在代码处理过程中需要维护多处。

2、大部分都是基于系统的UIImagePickerController，定制化程度低，切换时需要开发大部分代码

3、之前存在部分UIImagePickerController的crash，调查发现是
`*** setObjectForKey: object cannot be nil (key: UIImagePickerControllerOriginalImage)`，与UIImagePickerController无关。

4、之前的逻辑为了同步selecteImage和管理多图片之间的调用逻辑，需要在多个页面之间传递P1ImagePickerManager，使页面之间的耦合程度提高，清晰程度不够。

# 简介：

## Feature
- 支持调用系统的UIImagePickerController
- 支持单图、多图片选择、视频选择
- 与原生UIImagePickerController使用保持一致，并且支持自定义的多图展示选择样式，保证灵活性
- 支持现在工程中所有的图片、视频选择的替换（正在验证有没有bug）
- 代码布局，修改灵活
- 支持图片、视频拍摄
- 其他功能待总结

大致步骤：
初始化后 -> 展示，通过Delegate回调，获取并且处理结果

```
/**
 suscess callBack After Finish picking the images
 @param picker : the custom picker, you can get some useful attribute of  PIImagePickerController.
 @param images : the images selected by user. member's type is P1ImageAsset
 */
- (void)P1_imagePickerController:(PIImagePickerController *)picker didFinishPickingImages:(nullable NSArray<P1ImageAsset *> *)images;

/**
 cancel callBack

 @param picker : the custom picker, you can get some useful attribute of  PIImagePickerController
 */
- (void)P1_imagePickerControllerDidCancel:(PIImagePickerController *)picker;
```
## 使用方法

### 调用系统的UIImagePickerController
```
- (void)pickSystemVCClicked
{
//注意，这里必须要作为属性持有
    self.customImagePickerController = [[P1ImagePickerController alloc] init];
    self.customImagePickerController.delegate = self;
    [self presentViewController:self.customImagePickerController.imagePickerController animated:YES completion:^{
    }];
}

- (void)P1_imagePickerController:(PIImagePickerController *)picker didFinishPickingImages:(NSArray<P1ImageAsset *> *)images
{
    NSLog(@"finish call Back Images count %@", @([images count]));

    [self _dismissImagePickController];
}

- (void)_dismissImagePickController
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

```

### 多图选择

因为多图选择，需要push 和 pop 操作，所以这里自定义了一个P1ImagePickerNavigationController，并且把P1ImagePickerController作为rootViewController传进去，由于核心逻辑都封装在P1ImagePickerController中，所以我们可以个性化定义NavigationController
```
- (void)pickCustomVCClicked
{
       self.navigationController.navigationBarHidden = YES;
    PIImagePickerController *vc = [[PIImagePickerController alloc] init];
    UIBarButtonItem *rightBarItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_dismissImagePickController)];
    vc.navigationItem.rightBarButtonItem = rightBarItem;
    P1ImagePickerNavigationController *nav = [[P1ImagePickerNavigationController alloc] initWithRootViewController:vc];
    nav.imagePickerController.delegate = self;
    [self presentViewController:nav animated:YES completion:^{
    }];
}

Delegate回调同上面

```


## 流程图

imagePickerFlow.png![](https://i.imgur.com/zYK0kY5.png)


## 模块功能介绍
Model（Data）区
P1ImageAsset：图片的数据结构
P1AlbumInfo：相册的数据结构
P1ImageCollercionDataSource:获取图片的数据源

P1ImagePickerController:核心逻辑区，实现页面逻辑跳转、数据源传递、结果回调
P1ImageCollectionDataSource:自定义多图的图片选择页面
P1ImageAlbumTableViewController:相册列表
P1ImagePickerNavigationController：封装的nav，方便页面间的push和pop


# 问题及TODO
- 细节容错处理
- 缓存、大图处理、压缩
- 融入工程
- Demo测试功能完善

