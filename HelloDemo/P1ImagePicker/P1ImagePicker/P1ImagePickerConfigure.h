//
//  P1ImagePickerConfigure.h
//  HelloDemo
//
//  Created by haojianliang on 2017/11/17.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface P1ImagePickerConfigure : NSObject

//use the enum
@property (nonatomic, assign) NSInteger type;

/**
 最大选择图片的数量
 */
@property (nonatomic, assign) NSUInteger maxSelectedImageCount;

/**
 自定义CollectionView的配置
 */
@property (nonatomic, strong) UICollectionViewLayout *layout;
@property (nonatomic, strong) Class customCollectionCellClass;

+ (P1ImagePickerConfigure *)defaultConfigure;

@end
