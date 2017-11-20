//
//  P1ImagePickerDataSource.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "P1ImagePickerDataSource.h"
#import <Photos/Photos.h>
#import "P1AlbumInfo.h"

@interface P1ImagePickerDataSource()

@property (nonatomic, strong) PHFetchOptions *fetchOptions;

@end

@implementation P1ImagePickerDataSource

- (instancetype)initWithFetchOptions:(PHFetchOptions *)fetchOptions
{
    self = [super init];
    if (self) {
        _fetchOptions = fetchOptions;
    }
    return self;
}

- (void)populateAlbums {
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *topLevelUserCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:(PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumMyPhotoStream | PHAssetCollectionSubtypeAlbumCloudShared) options:nil];
    NSMutableArray *albumInfos = [self albumInfoFilteredFromFetchResult:smartAlbums].mutableCopy;
    [albumInfos addObjectsFromArray:[self albumInfoFilteredFromFetchResult:topLevelUserCollections]];
    
    if (![self.albumInfoArray isEqualToArray:albumInfos]) {
        self.albumInfoArray = albumInfos;
    }
}

- (NSArray *)albumInfoFilteredFromFetchResult:(PHFetchResult *)fetchResult {
    NSMutableArray *albumInfos = [NSMutableArray array];
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:self.fetchOptions];
        if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
            // album: "All Photos"
            [albumInfos insertObject:[[P1AlbumInfo alloc] initWithCollection:collection count:result.count] atIndex:0];
        } else if (collection.assetCollectionSubtype == 1000000201) {
            // album: "Recently Deleted"
        } else if (result.count > 0) {
            [albumInfos addObject:[[P1AlbumInfo alloc] initWithCollection:collection count:result.count]];
        }
    }];
    return albumInfos;
}

@end
