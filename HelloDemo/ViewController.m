//
//  ViewController.m
//  HelloDemo
//
//  Created by haojianliang on 2017/11/13.
//  Copyright © 2017年 haojianliang. All rights reserved.
//

#import "ViewController.h"
#import "HJLOriginPickViewController.h"

NSString * const kFeatureTableViewIdentify = @"kFeatureTableViewIdentify";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *featureTableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UINavigationController *nav;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.dataSource = @[@{@"name":@"OriginImagePick",
                          @"controllerName":@"HJLOriginPickViewController"
                          }];
    
    self.featureTableView.delegate = self;
    self.featureTableView.dataSource = self;
    
    self.featureTableView.tableFooterView = [[UIView alloc] init];
        
    self.nav = [[UINavigationController alloc] initWithRootViewController:self];
    [[[UIApplication sharedApplication] delegate] window].rootViewController = self.nav;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview
#pragma mark -tableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeatureTableViewIdentify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
    }
    NSString *name = [self.dataSource[indexPath.row] objectForKey:@"name"];
    cell.textLabel.text = name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.featureTableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *className = [self.dataSource[indexPath.row] objectForKey:@"controllerName"];
    Class VC = NSClassFromString(className);
    UIViewController *vc = [[VC alloc] init];
    if (vc) {
        [self.nav pushViewController:vc animated:YES];
    }
}
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

@end
