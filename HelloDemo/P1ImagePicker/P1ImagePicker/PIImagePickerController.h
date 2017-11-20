//
//  PIImagePickerController.h
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PIImagePickerController;
@class P1ImagePickerConfigure;
@class P1ImageAsset;

NS_ASSUME_NONNULL_BEGIN

@protocol P1ImagePickerControllerDelegate <NSObject>

@optional
// The picker does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0);

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

@end


@interface PIImagePickerController : UIViewController<P1ImagePickerControllerDelegate>

@property (nonatomic, weak) id<P1ImagePickerControllerDelegate> delegate;

/**
 提供系统的UIImagePickerController方法，使用方法：
 [viewcontroller presentViewController:PIImagePickerController.imagePickerController]
 */
@property (nonatomic, strong) UIImagePickerController *systemImagePickerController;

/**
 初始化

 @param configure 配置不同的PIImagePickerController，configure 不能为nil，现在兜底，如果为nil，在使用[P1ImagePickerConfigure defaultCongifure]
 @return PIImagePickerController实例
 */
- (instancetype)initWithImagePickerConfigure:(nonnull P1ImagePickerConfigure *)configure;

@end

NS_ASSUME_NONNULL_END
