//
//  P1ImageShootCollectionViewCell.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/24.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "P1ImageShootCollectionViewCell.h"

static CGFloat kImageWidth = 10;
@interface P1ImageShootCollectionViewCell()

/**
 加号
 */
@property (nonatomic, strong) UILabel *backgroundImageView;

@end

@implementation P1ImageShootCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundImageView = [[UILabel alloc] init];
        _backgroundImageView.numberOfLines = 0;
        _backgroundImageView.text = @"拍摄图片\n视频";
        _backgroundImageView.frame = CGRectMake(kImageWidth, kImageWidth, self.contentView.frame.size.width - kImageWidth * 2, self.contentView.frame.size.height - kImageWidth * 2);
        [self.contentView addSubview:_backgroundImageView];
    }
    return self;
}

@end
