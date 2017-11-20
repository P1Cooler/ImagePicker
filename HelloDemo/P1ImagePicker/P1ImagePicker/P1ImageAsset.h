//
//  P1ImageAsset.h
//  P1
//
//  Created by Mikael on 8/24/15.
//  Copyright (c) 2015 P1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

typedef void(^RequestImageCompletionBlock)(UIImage * __nullable result, NSDictionary * __nullable info);
typedef void(^RequestPHAssetMetaDataCompletionBlock)(NSDictionary * __nullable info);

typedef NS_ENUM(NSUInteger, P1ImageAssetType) {
    P1ImageAssetTypePHAsset,
    P1ImageAssetTypeUIImage,
    P1ImageAssetTypeVideo
};

NS_ASSUME_NONNULL_BEGIN

@interface P1ImageAsset : NSObject

/**
 初始化相册资源，获取Image使用
 */
@property (nonatomic, strong, readonly, nullable) id originAsset;

/**
 展示的图像，asset初始化时为nil，需要request
 */
@property (nonatomic, strong) UIImage *image;

/**
 不同初始化方法，设置不同的type
 */
@property (nonatomic, readonly) P1ImageAssetType type;

/**
 视频资源URL
 */
@property (nonatomic, strong) NSURL *videoURL;

- (instancetype)initWithPHAsset:(PHAsset *)asset;
- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithVideo:(NSURL *)videoURL;

//- (void)requestImageWithCompletion:(RequestImageCompletionBlock)completion;
//- (void)requestPHAssetMetaData:(PHAsset *)asset withCompletion:(RequestPHAssetMetaDataCompletionBlock)complection;
//
//- (void)cancelImageRequest;

@end

NS_ASSUME_NONNULL_END
