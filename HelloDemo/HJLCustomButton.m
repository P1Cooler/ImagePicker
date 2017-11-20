//
//  HJLCustomButton.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/14.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "HJLCustomButton.h"

@implementation HJLCustomButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, UIEdgeInsetsMake(-10, -10, -10, -10));
    BOOL inside = CGRectContainsPoint(hitFrame, point);
    
//    NSLog(@"Cooler : original : %@, hit : %@ , result :%@", NSStringFromCGRect(relativeFrame), NSStringFromCGRect(hitFrame), @(inside));
    return inside;
}
@end
