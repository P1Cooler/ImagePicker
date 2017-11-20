//
//  P1ImagePickerNavigationController.h
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PIImagePickerController.h"

@interface P1ImagePickerNavigationController : UINavigationController

@property (nonatomic, strong, readonly) PIImagePickerController *imagePickerController;

@end
