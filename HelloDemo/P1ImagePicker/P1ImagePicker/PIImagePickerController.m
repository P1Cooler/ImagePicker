//
//  PIImagePickerController.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "PIImagePickerController.h"
#import "P1ImageAlbumTableViewController.h"
#import "P1ImageCollectionViewController.h"
#import "P1ImagePickerDataSource.h"
#import <Masonry/Masonry.h>
#import <Photos/Photos.h>
#import "P1AlbumInfo.h"
#import "P1ImageAsset.h"
#import "P1ImagePickerConfigure.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "P1ImagePreviewCollectionViewController.h"

@interface PIImagePickerController ()<UIImagePickerControllerDelegate>

@property (nonatomic, strong) P1ImageAlbumTableViewController *albumTableVC;
@property (nonatomic, strong) P1ImageCollectionViewController *imageCollectVC;
@property (nonatomic, strong) P1ImagePreviewCollectionViewController *previewVC;

@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) P1ImagePickerDataSource *imagePickerModel;
@property (nonatomic, strong) NSMutableArray *selectedImages;

@property (nonatomic, strong) P1ImagePickerConfigure *configure;


@end

@implementation PIImagePickerController

- (instancetype)initWithImagePickerConfigure:(nonnull P1ImagePickerConfigure *)configure
{
    if (self = [super init]) {
        NSAssert(configure != nil, @"configure must not be nil");
        _configure = configure ?: [P1ImagePickerConfigure defaultConfigure];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithImagePickerConfigure:[P1ImagePickerConfigure defaultConfigure]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.albumTableVC.view];
    [self addChildViewController:self.albumTableVC];
    [self.albumTableVC willMoveToParentViewController:self];
    
    [self.imageCollectVC.view addSubview:self.previewButton];
    [self.imageCollectVC.view addSubview:self.doneButton];
    [self.imageCollectVC.view bringSubviewToFront:self.previewButton];
    [self.imageCollectVC.view bringSubviewToFront:self.doneButton];
    
    [self.imagePickerModel populateAlbums];
    self.albumTableVC.albumList = self.imagePickerModel.albumInfoArray;
    [self.albumTableVC.tableView reloadData];
}

- (void)updateViewConstraints
{
    [self.albumTableVC.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    [self.previewButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.left.equalTo(self.imageCollectVC.view.mas_left);
        make.bottom.equalTo(self.imageCollectVC.view.mas_bottom);
    }];
    
    [self.doneButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.imageCollectVC.view.mas_bottom);
        make.right.equalTo(self.imageCollectVC.view.mas_right);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - Target Action
- (void)doneButtonClicked
{
    if (self.selectedImages.count > 0) {
        if ([self.delegate respondsToSelector:@selector(P1_imagePickerController:didFinishPickingImages:)]) {
            [self.delegate P1_imagePickerController:self didFinishPickingImages:self.selectedImages];
        }
    }
}

- (void)previewButtonClicked
{
    if (self.selectedImages.count > 0) {
        self.previewVC.selectedImages = [self.selectedImages copy];
        [self.previewVC.collectionView reloadData];
        [self.navigationController pushViewController:self.previewVC animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    P1ImageAsset *asset = nil;
    if ([info[UIImagePickerControllerMediaType] isEqual:(NSString*)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        if (videoURL) {
            asset = [[P1ImageAsset alloc] initWithVideo:videoURL];
        }
    } else {
        UIImage *contentImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        asset = [[P1ImageAsset alloc] initWithImage:contentImage];
    }
    
    
    if (asset && [self.delegate respondsToSelector:@selector(P1_imagePickerController:didFinishPickingImages:)]) {
        NSArray<P1ImageAsset *> *images = asset ? [NSArray arrayWithObject:asset] : nil;
        [self.delegate P1_imagePickerController:self didFinishPickingImages:images];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if ([self.delegate respondsToSelector:@selector(P1_imagePickerControllerDidCancel:)]) {
        [self.delegate P1_imagePickerControllerDidCancel:self];
    }
}


#pragma mark - Get
- (UIImagePickerController *)systemImagePickerController
{
    if (!_systemImagePickerController) {
        _systemImagePickerController = [[UIImagePickerController alloc] init];
        _systemImagePickerController.delegate = self;
    }
    return _systemImagePickerController;
}

- (UIButton *)previewButton
{
    if (!_previewButton) {
        _previewButton = [[UIButton alloc] init];
        _previewButton.backgroundColor = [UIColor grayColor];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        
        [_previewButton addTarget:self action:@selector(previewButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    }
    return _previewButton;
}

- (UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] init];
        _doneButton.backgroundColor = [UIColor grayColor];
        [_doneButton setTitle:@"提交" forState:UIControlStateNormal];
        
        [_doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (P1ImageAlbumTableViewController *)albumTableVC
{
    if (!_albumTableVC) {
        _albumTableVC = [[P1ImageAlbumTableViewController alloc] init];
        __weak typeof(self) weakSelf = self;
        _albumTableVC.cellClickBlock = ^(NSIndexPath *indexPath){
            __strong typeof(weakSelf) self = weakSelf;
            P1AlbumInfo *albumInfo = self.imagePickerModel.albumInfoArray[indexPath.row];
            PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:albumInfo.collection options:nil];
            self.imageCollectVC.assets = assets;
            [self.imageCollectVC.collectionView reloadData];
            [self.navigationController pushViewController:weakSelf.imageCollectVC animated:YES];
        };
    }
    return _albumTableVC;
}

- (P1ImageCollectionViewController *)imageCollectVC
{
    if (!_imageCollectVC) {
  
        _imageCollectVC = [[P1ImageCollectionViewController alloc] initWithImagePickerConfigure:self.configure];
        
        __weak typeof(self) weakSelf = self;

        _imageCollectVC.cellClickBlock = ^(NSIndexPath *indexPath){
            __strong typeof(weakSelf) self = weakSelf;
            if (self.selectedImages.count > 0) {
                //完成的数量变化
                self.doneButton.backgroundColor = [UIColor redColor];
                self.previewButton.backgroundColor = [UIColor redColor];
                [self.doneButton setTitle:[@(self.selectedImages.count) stringValue] forState:UIControlStateNormal];
            } else {
                self.doneButton.backgroundColor = [UIColor grayColor];
                self.previewButton.backgroundColor = [UIColor grayColor];
                [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
            }

        };
    }
    return _imageCollectVC;
}

- (P1ImagePreviewCollectionViewController *)previewVC
{
    if (!_previewVC) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.itemSize = self.view.frame.size;
        _previewVC = [[P1ImagePreviewCollectionViewController alloc] initWithCollectionViewLayout:layout];
    }
    return _previewVC;
}

- (P1ImagePickerDataSource *)imagePickerModel
{
    if (!_imagePickerModel) {
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
        _imagePickerModel = [[P1ImagePickerDataSource alloc] initWithFetchOptions:fetchOptions];
    }
    return _imagePickerModel;
}

- (nullable NSMutableArray *)selectedImages
{
    if (!_imageCollectVC) return nil;
    return self.imageCollectVC.selectedImages;
}
@end
