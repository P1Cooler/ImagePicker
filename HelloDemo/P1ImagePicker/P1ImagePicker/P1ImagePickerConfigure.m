//
//  P1ImagePickerConfigure.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/17.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "P1ImagePickerConfigure.h"

@interface P1ImagePickerConfigure()

@end

@implementation P1ImagePickerConfigure


+ (P1ImagePickerConfigure *)defaultConfigure
{
    P1ImagePickerConfigure *configure = [[P1ImagePickerConfigure alloc] init];
    
    configure.maxSelectedImageCount = 9;
    configure.useCustomShootCell = NO;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 1.0 / 4.0 - 6.0;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    layout.itemSize = CGSizeMake(width, width);
    configure.layout = layout;
    
    return configure;
}

@end
