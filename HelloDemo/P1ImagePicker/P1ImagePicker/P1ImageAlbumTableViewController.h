//
//  P1ImageAlbumTableViewController.h
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class P1AlbumInfo;

@interface P1ImageAlbumTableViewController : UITableViewController

@property (nonatomic, strong) NSArray<P1AlbumInfo *> *albumList;
@property (nonatomic, copy) void (^cellClickBlock)(NSIndexPath *indexPath);

@end
