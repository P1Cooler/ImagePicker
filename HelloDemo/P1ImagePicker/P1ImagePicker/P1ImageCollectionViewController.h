//
//  P1ImageCollectionViewController.h
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHFetchResult;
@class P1ImagePickerConfigure;
@class P1ImageAsset;

typedef NS_ENUM(NSUInteger, P1ImageCollectionViewCellType) {
    P1ImageCollectionViewCellTypeShoot, //拍摄Cell
    P1ImageCollectionViewCellTypeNormal,//正常展示的Cell
};

NS_ASSUME_NONNULL_BEGIN;

@interface P1ImageCollectionViewController : UICollectionViewController
/**
 Collection的数据源
 */
@property (nonatomic, strong) PHFetchResult *assets;

/**
 选中Cell的Block回调
 */
@property (nonatomic, copy) void (^cellClickBlock)(NSIndexPath *indexPatt, P1ImageCollectionViewCellType type);

/**
 已选的图片列表
 */
@property (nonatomic, strong, readonly) NSMutableArray<P1ImageAsset *> *selectedImages;


/**
 初始化方法

 @param configure 配置不同的PIImagePickerController，如果为nil，在使用[P1ImagePickerConfigure defaultCongifure]
 @return 返回实例
 */
- (instancetype)initWithImagePickerConfigure:(P1ImagePickerConfigure *)configure;

@end

NS_ASSUME_NONNULL_END;
