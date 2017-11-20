//
//  P1ImagePreviewCollectionViewCell.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/20.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "P1ImagePreviewCollectionViewCell.h"

@implementation P1ImagePreviewCollectionViewCell

- (UIImageView *)pickImageView
{
    if (!_pickImageView) {
        _pickImageView = [[UIImageView alloc] init];
        _pickImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_pickImageView];
        _pickImageView.frame = [UIScreen mainScreen].bounds
;
    }
    return _pickImageView;
}
@end
