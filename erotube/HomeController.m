//
//  HomeController.m
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "HomeController.h"
#import "DataManager.h"
#import "VideoListCell.h"
#import "VideoListHeader.h"
#import "VideoDetailController.h"
#import "Utils.h"

#import <Haneke/Haneke.h>
#import <SVPullToRefresh/SVPullToRefresh.h>

typedef NS_ENUM(NSInteger, ETHomeControllerState) {
  ETHomeControllerStateNormal,
  ETHomeControllerStateUpdating
};

const NSInteger CATEGORIES_PER_REFRESH = 4;
const NSInteger VIDEOS_PER_CATEGORY = 3;

@interface HomeController ()

@property(nonatomic, strong) DataManager *manager;
@property(nonatomic) NSInteger state;
@property(nonatomic) NSInteger showedSections;

@end

@implementation HomeController

- (NSString *)title {
  return @"Home";
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _manager = [DataManager manager];
  _state = ETHomeControllerStateNormal;
  _showedSections = 0;

  [_videoTableView
                 registerNib:[UINib nibWithNibName:@"VideoListCell" bundle:nil]
      forCellReuseIdentifier:@"VideoListCell"];
  [_videoTableView registerNib:[UINib nibWithNibName:@"VideoListHeader"
                                              bundle:nil]
      forHeaderFooterViewReuseIdentifier:@"VideoListHeader"];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
  [super didMoveToParentViewController:parent];
  if (_videoTableView.pullToRefreshView == nil) {
    __weak HomeController *self_ = self;
    [_videoTableView addPullToRefreshWithActionHandler:^{
      [self_ refreshDataForce:YES];
    }];
    [_videoTableView addInfiniteScrollingWithActionHandler:^{
      [self_ refreshDataForce:NO];
    }];
    [_videoTableView triggerPullToRefresh];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [_videoTableView
      deselectRowAtIndexPath:_videoTableView.indexPathForSelectedRow
                    animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)refreshDataForce:(BOOL)force {
  _state = ETHomeControllerStateUpdating;
  [_manager fetchCategoriesForce:NO].then(
      ^(NSArray *categories, NSDictionary *counts, NSDictionary *hrefs) {
        if (force) _showedSections = 0;
        NSInteger length =
            MIN(CATEGORIES_PER_REFRESH, categories.count - _showedSections);
        NSArray *categoriesNeedShow =
            [categories subarrayWithRange:NSMakeRange(_showedSections, length)];
        _showedSections += length;
        NSMutableArray *works = [[NSMutableArray alloc] init];
        for (NSString *category in categoriesNeedShow) {
          [works addObject:[_manager fetchVideoListByCategory:category
                                                         page:1
                                                        force:force].then(^{
            [_videoTableView reloadData];
          })];
        }
        [PMKPromise when:works].then(^{
          [_videoTableView.pullToRefreshView stopAnimating];
          [_videoTableView.infiniteScrollingView stopAnimating];
        });
        _state = ETHomeControllerStateNormal;
        [_videoTableView reloadData];
      });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (_state == ETHomeControllerStateNormal) {
    return _showedSections;
  }
  return 0;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if (_state == ETHomeControllerStateNormal) {
    NSString *category = _manager.categories[section];
    NSArray *videos = _manager.allVideos[category][@(1)];
    if (videos == nil) {
      return VIDEOS_PER_CATEGORY;
    } else {
      return MIN(VIDEOS_PER_CATEGORY, videos.count);
    }
  }
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  VideoListCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"VideoListCell"
                                      forIndexPath:indexPath];
  return cell;
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  VideoListCell *videoListCell = (VideoListCell *)cell;
  NSString *category = _manager.categories[indexPath.section];
  NSArray *videos = _manager.allVideos[category][@(1)];
  VideoModel *videoModel = [[VideoModel alloc] init];
  if (videos) {
    videoModel = videos[indexPath.row];
  }
  [videoListCell setupWithVideoModel:videoModel];
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  return [tableView
      dequeueReusableHeaderFooterViewWithIdentifier:@"VideoListHeader"];
}

- (void)tableView:(UITableView *)tableView
    willDisplayHeaderView:(UIView *)view
               forSection:(NSInteger)section {
  VideoListHeader *header = (VideoListHeader *)view;
  NSString *category = _manager.categories[section];
  NSString *categoryTranslation = _manager.categoryTranslations[category];
  if (categoryTranslation != nil) {
    header.categoryLabel.text =
        [category stringByAppendingFormat:@" / %@", categoryTranslation];
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 32;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *category = _manager.categories[indexPath.section];
  NSArray *videos = _manager.allVideos[category][@(1)];
  if (videos) {
    VideoModel *videoModel = videos[indexPath.row];
    VideoDetailController *videoDetailController =
        [[VideoDetailController alloc] init];
    videoDetailController.videoModel = videoModel;
    [self.navigationController pushViewController:videoDetailController
                                         animated:YES];
  }
}

@end
