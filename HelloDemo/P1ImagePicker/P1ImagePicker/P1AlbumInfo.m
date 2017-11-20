//
//  P1AlbumInfo.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "P1AlbumInfo.h"
#import <Photos/Photos.h>

@implementation P1AlbumInfo

- (instancetype)initWithCollection:(PHAssetCollection *)collection count:(NSUInteger)count {
    if (self = [super init]) {
        self.collection = collection;
        self.count = count;
        self.title = collection.localizedTitle;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[P1AlbumInfo class]]) { return NO; }
    P1AlbumInfo *album = (P1AlbumInfo *)object;
    return [album.collection isEqual:self.collection] && album.count == self.count;
}

- (NSUInteger)hash {
    return self.collection.hash + self.count;
}

@end

