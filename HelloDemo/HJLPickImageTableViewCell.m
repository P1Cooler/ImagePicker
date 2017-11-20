//
//  HJLPickImageTableViewCell.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/15.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "HJLPickImageTableViewCell.h"

@interface HJLPickImageTableViewCell()

@end

@implementation HJLPickImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UIImageView *)pickImageView
{
    if (!_pickImageView) {
        _pickImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_pickImageView];
        _pickImageView.frame = CGRectMake(0, 0, 90, 90);
    }
    return _pickImageView;
}


@end
