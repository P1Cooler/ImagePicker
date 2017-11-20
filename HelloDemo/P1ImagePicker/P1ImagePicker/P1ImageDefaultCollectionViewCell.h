//
//  P1ImageDefaultCollectionViewCell.h
//  HelloDemo
//
//  Created by haojianliang on 2017/11/20.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class P1ImageAsset;

NS_ASSUME_NONNULL_BEGIN;

/**
 默认相册详情页的Cell
 */
@interface P1ImageDefaultCollectionViewCell : UICollectionViewCell

/**
 input : 输入数据源
 */
@property (nonatomic, strong) P1ImageAsset *imageAsset;

@end

NS_ASSUME_NONNULL_END;
