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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(120, 100);
    configure.layout = layout;
    
    return configure;
}

@end
