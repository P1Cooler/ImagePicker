//
//  P1ImagePickerDataSource.h
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PHFetchOptions;
@class P1AlbumInfo;

NS_ASSUME_NONNULL_BEGIN

@interface P1ImagePickerDataSource : NSObject

/**
 output:相册tableView的数据源
 */
@property (nonatomic, strong) NSArray<P1AlbumInfo *> *albumInfoArray;


/**
 初始化数据源方法，后调用populateAlbums方法，可以得到数据源albumInfoArray

 @param fetchOptions 数据源配置项
 @return 实例
 */
- (instancetype)initWithFetchOptions:(PHFetchOptions *)fetchOptions;

/**
 生成数据源
 */
- (void)populateAlbums;

@end

NS_ASSUME_NONNULL_END
