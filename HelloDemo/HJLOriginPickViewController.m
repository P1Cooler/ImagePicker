//
//  HJLOriginPickViewController.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/14.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "HJLOriginPickViewController.h"
#import <UIKit/UIImagePickerController.h>
#import "HJLCustomButton.h"
#import <Photos/Photos.h>
#import "HJLPickImageTableViewCell.h"
#import "ReactiveCocoa/ReactiveCocoa.h"
#import "P1ImagePickerNavigationController.h"
#import <MobileCoreServices/UTCoreTypes.h>

#import "P1ImageAsset.h"

#import "PIImagePickerController.h"

NSUInteger const kImageViewHeight = 100;
NSString *const kPickImageTableViewIdentify = @"kPickImageTableViewIdentify";

@interface HJLOriginPickViewController ()<UIImagePickerControllerDelegate, UICollectionViewDelegate,UICollectionViewDataSource, UINavigationControllerDelegate, P1ImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickController;
@property (nonatomic, strong) HJLCustomButton *pickSingleButton;
@property (nonatomic, strong) UIImageView *selectSingleImageView;

@property (nonatomic, strong) HJLCustomButton *pickMoreButton;
@property (nonatomic, strong) UICollectionView *selectedMoreCollectView;
@property (nonatomic, strong) NSArray <UIImage *> *selectedImages;

@property (nonatomic, strong) HJLCustomButton *pickVideoButton;

@property (nonatomic, strong) PIImagePickerController *customImagePickerController;
@property (nonatomic, strong) UIImageView *selectVideoView;

@end

@implementation HJLOriginPickViewController

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor grayColor];
    self.imagePickController = [[UIImagePickerController alloc] init];
    self.imagePickController.delegate = self;
    
    self.pickSingleButton = [[HJLCustomButton alloc] initWithFrame:CGRectMake(100, 100, 200, 40)];
    self.pickSingleButton.backgroundColor = [UIColor redColor];
    [self.pickSingleButton setTitle:@"选取单张照片" forState:UIControlStateNormal];
    [self.pickSingleButton addTarget:self action:@selector(pickSystemVCClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectSingleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 200, kImageViewHeight, kImageViewHeight)];
    self.selectSingleImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.pickMoreButton = [[HJLCustomButton alloc] initWithFrame:CGRectMake(100, 350, 200, 40)];
    self.pickMoreButton.backgroundColor = [UIColor redColor];
    [self.pickMoreButton setTitle:@"选取多张照片" forState:UIControlStateNormal];
    [self.pickMoreButton addTarget:self action:@selector(pickMoreButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(120, 100);
    self.selectedMoreCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 400, width, kImageViewHeight) collectionViewLayout:layout];
    self.selectedMoreCollectView.delegate = self;
    self.selectedMoreCollectView.dataSource = self;
    [self.selectedMoreCollectView registerClass:[HJLPickImageTableViewCell class] forCellWithReuseIdentifier:kPickImageTableViewIdentify];
    
    self.selectedImages = [NSArray array];
    
    self.pickVideoButton =	 [[HJLCustomButton alloc] initWithFrame:CGRectMake(100, 550, 200, 40)];
    self.pickVideoButton.backgroundColor = [UIColor redColor];
    [self.pickVideoButton setTitle:@"选取视频" forState:UIControlStateNormal];
    [self.pickVideoButton addTarget:self action:@selector(pickVideoButtonTouched) forControlEvents:UIControlEventTouchUpInside];
    self.selectVideoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 600, kImageViewHeight, kImageViewHeight)];
    self.selectVideoView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.pickSingleButton];
    [self.view addSubview:self.selectSingleImageView];
    
    [self.view addSubview:self.pickMoreButton];
    [self.view addSubview:self.selectedMoreCollectView];
    
    [self.view addSubview:self.pickVideoButton];
    [self.view addSubview:self.selectVideoView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Target Action
- (void)pickSystemVCClicked
{
    self.customImagePickerController = [[PIImagePickerController alloc] init];
    self.customImagePickerController.delegate = self;
    [self presentViewController:self.customImagePickerController.systemImagePickerController animated:YES completion:^{
    }];
    
    //will not work, think life cycle
    
//    PIImagePickerController *customImagePickerController = [[PIImagePickerController alloc] init];
//    customImagePickerController.delegate = self;
//    [self presentViewController:customImagePickerController.systemImagePickerController animated:YES completion:^{
//    }];
}

- (void)pickMoreButtonTouched
{
    self.navigationController.navigationBarHidden = YES;
    PIImagePickerController *vc = [[PIImagePickerController alloc] init];
    UIBarButtonItem *rightBarItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_dismissImagePickController)];
    vc.navigationItem.rightBarButtonItem = rightBarItem;
    P1ImagePickerNavigationController *nav = [[P1ImagePickerNavigationController alloc] initWithRootViewController:vc];
    nav.imagePickerController.delegate = self;
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (void)pickVideoButtonTouched
{
    self.customImagePickerController = [[PIImagePickerController alloc] init];
    self.customImagePickerController.delegate = self;
    self.customImagePickerController.systemImagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    self.customImagePickerController.systemImagePickerController.mediaTypes = @[(NSString*)kUTTypeMovie];
    self.customImagePickerController.systemImagePickerController.allowsEditing = YES;
    self.customImagePickerController.systemImagePickerController.videoMaximumDuration = 60.0f;
    self.customImagePickerController.systemImagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    self.customImagePickerController.systemImagePickerController.view.backgroundColor = [UIColor whiteColor];
    
    [self presentViewController:self.customImagePickerController.systemImagePickerController animated:YES completion:^{
    }];
}

#pragma mark - P1ImagePickerControllerDelegate

- (void)P1_imagePickerController:(PIImagePickerController *)picker didFinishPickingImages:(NSArray<P1ImageAsset *> *)images
{
    NSLog(@"已经提交了 %@", @([images count]));

    if (images.count > 0) {
        P1ImageAsset *imageAsset = images[0];
        if (imageAsset.type == P1ImageAssetTypeVideo) {
            //only show one;
            P1ImageAsset *imageAsset = images[0];
            
            UIImage *thumbImage = [self generateImageInVideo:imageAsset.videoURL atTime:kCMTimeZero withError:nil];
            self.selectVideoView.image = thumbImage;
        } else if (imageAsset.type == P1ImageAssetTypeUIImage) {
            P1ImageAsset *imageAsset = images[0];
            self.selectSingleImageView.image = imageAsset.image;
        } else if (imageAsset.type == P1ImageAssetTypePHAsset) {
            //自定义选择多张图片
            NSMutableArray *selectedImages = [NSMutableArray array];
            for (P1ImageAsset *imageAsset in images) {
                if (imageAsset.image) {
                    [selectedImages addObject:imageAsset.image];
                }
            }
            self.selectedImages = [selectedImages copy];
            [self.selectedMoreCollectView reloadData];
        }
    }
    [self _dismissImagePickController];

}

- (void)P1_imagePickerControllerDidCancel:(PIImagePickerController *)picker
{
    [self _dismissImagePickController];
}

- (void)_dismissImagePickController
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

#pragma mark - collectionView

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HJLPickImageTableViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPickImageTableViewIdentify forIndexPath:indexPath];
    cell.pickImageView.image = self.selectedImages[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.selectedImages.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - Helper

-(UIImage*)generateImageInVideo:(NSURL*)videoURL atTime:(CMTime)time withError:(NSError**)error
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *thumbError = nil;
    CGImageRef image = [generator copyCGImageAtTime:time actualTime:NULL error:&thumbError];
    UIImage *thumb = nil;
    if(thumbError || !image) {
//        if(error) { *error = [[P1Error alloc] initWithType:UnknownError andMessage:@"Could not generate thumbnail"]; }
    } else {
        thumb = [[UIImage alloc] initWithCGImage:image];
    }
    CGImageRelease(image);
    return thumb;
}

@end
