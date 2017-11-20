//
//  P1ImageCollectionViewController.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/16.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "P1ImageCollectionViewController.h"
#import <Photos/Photos.h>
#import "P1ImageAsset.h"
#import "P1ImagePickerConfigure.h"
#import "P1ImageDefaultCollectionViewCell.h"

@interface P1ImageCollectionViewController ()

@property (nonatomic, strong, readwrite) NSArray<P1ImageAsset *> *imageAssets;
@property (nonatomic, strong, readwrite) NSMutableArray<P1ImageAsset *> *selectedImages;

@property (nonatomic, strong) P1ImagePickerConfigure *configure;

@end

@implementation P1ImageCollectionViewController

static NSString * const kP1ImageCollectionViewCellIdentify = @"kP1ImageCollectionViewCellIdentify";

- (instancetype)initWithImagePickerConfigure:(P1ImagePickerConfigure *)configure
{
    NSAssert(configure != nil, @"configure is Nil");
    P1ImagePickerConfigure *pickerConfigure = configure ?: [P1ImagePickerConfigure defaultConfigure];
    self = [super initWithCollectionViewLayout:pickerConfigure.layout];
    if (self) {
        _configure = pickerConfigure;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedImages = [NSMutableArray array];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    [self.collectionView registerClass:self.configure.customCollectionCellClass ?: [P1ImageDefaultCollectionViewCell class] forCellWithReuseIdentifier:kP1ImageCollectionViewCellIdentify];
    // Do any additional setup after loading the view.
    
    self.collectionView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setAssets:(PHFetchResult *)assets
{
    if (_assets != assets) {
        _assets = assets;
        NSMutableArray *imageAssets = [NSMutableArray array];
        for (int i = 0; i < assets.count; i++) {
            PHAsset *asset = [self assetFromReversingIndex:i];
            P1ImageAsset *imageAsset = [[P1ImageAsset alloc] initWithPHAsset:asset];
            
            NSLog(@"Cooler ColleciontView Image  %@ ", imageAsset);
            [imageAssets addObject:imageAsset];
        }
        self.imageAssets = [imageAssets copy];
    }
}

- (nullable PHAsset *)assetFromReversingIndex:(NSInteger)index {
    NSInteger reverseIndex = (self.assets.count -1) - index;
    if (reverseIndex >= self.assets.count || reverseIndex < 0) { return nil; }
    return [self.assets objectAtIndex:reverseIndex];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageAssets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    P1ImageDefaultCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kP1ImageCollectionViewCellIdentify forIndexPath:indexPath];
    
    P1ImageAsset *imageAsset = self.imageAssets[indexPath.row];
    cell.imageAsset = imageAsset;
    BOOL isSelected = [self isSelectedImageAsset:imageAsset];
    
    if (!isSelected) {
        //未选中
        cell.backgroundColor = [UIColor grayColor];
    } else {
        //选中
        cell.backgroundColor = [UIColor greenColor] ;
    }

    // Configure the cell
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    P1ImageAsset *imageAsset = self.imageAssets[indexPath.row];
    BOOL isSelected = [self isSelectedImageAsset:imageAsset];
    if (isSelected) {
        [self.selectedImages removeObject:imageAsset];
    } else {
        if (self.selectedImages.count >= self.configure.maxSelectedImageCount) {
            //已经到最大值，弹Allert，直接return
            return;
        }
        [self.selectedImages addObject:imageAsset];
    }
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (isSelected) {
        //取消
        cell.backgroundColor = [UIColor grayColor];
    } else {
        //选中
        cell.backgroundColor = [UIColor greenColor];
    }
    
    if (self.cellClickBlock) {
        self.cellClickBlock(indexPath);
    }
}

#pragma mark - Helper
- (BOOL)isSelectedImageAsset:(P1ImageAsset *)imageAsset
{
    return [self.selectedImages containsObject:imageAsset];
}

@end
