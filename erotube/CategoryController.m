//
//  CategoryController.m
//  erotube
//
//  Created by stormluke on 2/23/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "CategoryController.h"

#import "DataManager.h"
#import "FilterHeaderCell.h"
#import "VideoListController.h"
#import "FilterController.h"

#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerBarButtonItem.h>

@interface CategoryController ()

@property(nonatomic, strong) DataManager *manager;

@end

@implementation CategoryController

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
  [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow
                            animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
  self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _manager = [DataManager manager];
  [_tableView registerClass:[FilterHeaderCell class]
      forCellReuseIdentifier:@"CategoryCell"];
  [_manager fetchCategoriesForce:NO].then(^() {
    [_tableView reloadData];
  });
  self.title = @"Category";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _manager.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [_tableView dequeueReusableCellWithIdentifier:@"CategoryCell"
                                       forIndexPath:indexPath];
  NSString *categoryName = _manager.categories[indexPath.row];
  NSString *category =
      [NSString stringWithFormat:@"%@ / %@", categoryName,
                                 _manager.categoryTranslations[categoryName]];
  NSString *count = [_manager.categoryCounts[categoryName] stringValue];
  cell.textLabel.text = category;
  cell.detailTextLabel.text = count;
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *category = _manager.categories[indexPath.row];
  OptionModel *option = [[OptionModel alloc] init];
  option.category = category;
  VideoListController *videoListController = [[VideoListController alloc] init];
  videoListController.optionModel = option;
  FilterController *filterController = [[FilterController alloc] init];
  filterController.optionModel = option;
  videoListController.filterController = filterController;
  MMDrawerController *drawerController = [[MMDrawerController alloc]
      initWithCenterViewController:videoListController
         rightDrawerViewController:filterController];
  [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
  [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
  videoListController.drawerController = drawerController;
  MMDrawerBarButtonItem *filterButton =
      [[MMDrawerBarButtonItem alloc] initWithTarget:videoListController
                                             action:@selector(showFilter)];
  drawerController.navigationItem.rightBarButtonItem = filterButton;
  self.hidesBottomBarWhenPushed = YES;
  [self.navigationController pushViewController:drawerController animated:YES];
}

@end
