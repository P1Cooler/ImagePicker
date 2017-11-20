//
//  P1ImageAsset.m
//  P1
//
//  Created by Mikael on 8/24/15.
//  Copyright (c) 2015 P1. All rights reserved.
//

#import "P1ImageAsset.h"
//#import "UIImage+Resize.h"

NS_ASSUME_NONNULL_BEGIN

@interface P1ImageAsset ()

@property (nonatomic, strong) id asset;
@property (nonatomic, assign) PHImageRequestID imageRequestID;
@property (nonatomic, readwrite) P1ImageAssetType type;
@end

@implementation P1ImageAsset

- (instancetype)initWithPHAsset:(PHAsset *)asset {
    if (self = [super init]) {
        _type = P1ImageAssetTypePHAsset;
        _asset = asset;
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _type = P1ImageAssetTypeUIImage;
        _image = image;
    }
    return self;
}

- (instancetype)initWithVideo:(NSURL *)videoURL {
    if (self = [super init]) {
        _type = P1ImageAssetTypeVideo;
        _videoURL = videoURL;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if(![object isKindOfClass:[P1ImageAsset class]]) {
        return NO;
    }
    P1ImageAsset *asset = (P1ImageAsset *)object;
    if (asset.type == P1ImageAssetTypeUIImage) {
        return [asset.image isEqual:self.image];
    }
    return  [asset.originAsset isEqual:self.originAsset];
}

- (void)requestImageWithCompletion:(void (^)(UIImage * __nullable, NSDictionary * __nullable))completion {
    switch (self.type) {
        case P1ImageAssetTypeUIImage:
            completion(self.image, nil);
            break;
        case P1ImageAssetTypePHAsset:
            [self requestImageForPHAsset:(PHAsset *)_asset withCompletion:completion];
            break;
        default:
            completion(nil, nil);
            break;
    }
}

- (void)requestImageForPHAsset:(PHAsset *)asset withCompletion:(RequestImageCompletionBlock)completion {
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        if (imageData) {
//            UIImage *image = [[UIImage imageWithData:imageData] imageWithShortSideIsMaximum960];
            UIImage *image = [UIImage imageWithData:imageData];
            [self requestPHAssetMetaData:asset withCompletion:^(NSDictionary * _Nullable info) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image, info);
                });
            }];
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, nil);
            });
        }
    }];
}

- (void)requestPHAssetMetaData:(PHAsset *)asset withCompletion:(RequestPHAssetMetaDataCompletionBlock)complection {
    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
    options.networkAccessAllowed = YES; //download asset metadata from iCloud if needed
    
    [asset requestContentEditingInputWithOptions:options completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info) {
        CIImage *fullImage = [CIImage imageWithContentsOfURL:contentEditingInput.fullSizeImageURL];
        
        complection(fullImage.properties);
    }];
}

- (void)cancelImageRequest {
    [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
}

- (id __nullable)originAsset {
    return self.asset;
}

@end

NS_ASSUME_NONNULL_END
