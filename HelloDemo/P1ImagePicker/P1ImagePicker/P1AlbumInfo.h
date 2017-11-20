//
//  P1AlbumInfo.h
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

/**
 相册详情页数据结构
 */
@interface P1AlbumInfo : NSObject

@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong, nullable) UIImage *thumbnail;

- (instancetype)initWithCollection:(PHAssetCollection *)collection count:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
