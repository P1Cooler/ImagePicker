//
//  P1ImagePreviewCollectionViewController.h
//  HelloDemo
//
//  Created by haojianliang on 2017/11/20.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class P1ImageAsset;

NS_ASSUME_NONNULL_BEGIN;

@interface P1ImagePreviewCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSArray<P1ImageAsset *> *selectedImages;

@end

NS_ASSUME_NONNULL_END;
