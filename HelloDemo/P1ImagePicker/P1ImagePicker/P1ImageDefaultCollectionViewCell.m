//
//  P1ImageDefaultCollectionViewCell.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/20.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "P1ImageDefaultCollectionViewCell.h"
#import "P1ImageAsset.h"

@interface P1ImageDefaultCollectionViewCell()

@property (nonatomic, strong) UIImageView *thumbImageView;
@property (nonatomic, strong) PHImageManager *phImageManager;

@end

@implementation P1ImageDefaultCollectionViewCell

- (void)setImageAsset:(P1ImageAsset *)imageAsset
{
    if (imageAsset != _imageAsset) {
        _imageAsset = imageAsset;
        __weak typeof(self) weakSelf = self;
        CGFloat width = self.contentView.frame.size.width - 10;
        [self.phImageManager requestImageForAsset:imageAsset.originAsset targetSize:CGSizeMake(width, width) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            __strong typeof(weakSelf) self = weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    self.thumbImageView.image = result;
                    self.imageAsset.image = result;
//                    weakSelf.imageSelectionButton.enabled = YES;
                }
            });
        }];
    }
}

- (UIImageView *)thumbImageView
{
    if (!_thumbImageView) {
        _thumbImageView = [[UIImageView alloc] init];
        CGFloat width = self.contentView.frame.size.width - 10;

        [self.contentView addSubview:_thumbImageView];
        _thumbImageView.frame = CGRectMake(5, 5, width, width);
    }
    return _thumbImageView;
}

- (PHImageManager *)phImageManager
{
    if (!_phImageManager) {
        _phImageManager = [PHImageManager defaultManager];
    }
    return _phImageManager;
}

@end
