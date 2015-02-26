//
//  VideoListController.m
//  erotube
//
//  Created by stormluke on 2/24/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "VideoListController.h"
#import "DataManager.h"
#import "VideoListCell.h"
#import "VideoDetailController.h"

#import <SVPullToRefresh/SVPullToRefresh.h>

typedef NS_ENUM(NSInteger, ETVideoListControllerState) {
  ETVideoListControllerStateNormal,
  ETVideoListControllerStateUpdating
};

@interface VideoListController ()

@property(nonatomic, strong) DataManager *manager;
@property(nonatomic) NSInteger length;
@property(nonatomic) BOOL hasMore;
@property(nonatomic) ETVideoListControllerState state;

@end

@implementation VideoListController

- (NSString *)title {
  return @"VideoList";
}

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _manager = [DataManager manager];
  _length = 0;
  _hasMore = YES;
  _state = ETVideoListControllerStateNormal;

  [_tableView registerNib:[UINib nibWithNibName:@"VideoListCell" bundle:nil]
      forCellReuseIdentifier:@"VideoListCell"];
  self.title = _optionModel.category;

  __weak VideoListController *self_ = self;
  _filterController.didChangeOption = ^(OptionModel *option) {
    NSLog(@"Changed");
    NSLog(@"%@", option);
    self_.state = ETVideoListControllerStateUpdating;
    [self_.tableView reloadData];
    [self_.tableView triggerPullToRefresh];
  };
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
  [super didMoveToParentViewController:parent];
  if (_tableView.pullToRefreshView == nil) {
    __weak VideoListController *self_ = self;
    [_tableView addPullToRefreshWithActionHandler:^{
      [self_ refreshDataForce:YES];
    }];
    [_tableView addInfiniteScrollingWithActionHandler:^{
      [self_ refreshDataForce:NO];
    }];
    [_tableView triggerPullToRefresh];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow
                            animated:YES];
}

- (void)refreshDataForce:(BOOL)force {
  if (force) {
    _length = 0;
    _hasMore = YES;
  }
  if (_hasMore) {
    NSInteger page = _length / ET_VIDEO_PER_PAGE + 1;
    [_manager fetchVideoListByCategory:_optionModel.category
                                  page:page
                               options:_optionModel
                                 force:force]
        .then(^(NSDictionary *videoByCategory, NSDictionary *allVideos) {
          NSArray *videos = videoByCategory[@(page)];
          _length += videos.count;
          if (videos.count < ET_VIDEO_PER_PAGE) {
            _hasMore = NO;
          }
          self.title = _optionModel.category;
          _state = ETVideoListControllerStateNormal;
          [_tableView reloadData];
          [_tableView.pullToRefreshView stopAnimating];
          [_tableView.infiniteScrollingView stopAnimating];
        })
        .catch(^(NSError *error) {
          NSLog(@"%@", error);
        });
  } else {
    [_tableView.infiniteScrollingView stopAnimating];
  }
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  switch (_state) {
    case ETVideoListControllerStateUpdating:
      return 0;
      break;
    default:
      return _length;
      break;
  }
  return _length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  VideoListCell *cell =
      [_tableView dequeueReusableCellWithIdentifier:@"VideoListCell"
                                       forIndexPath:indexPath];
  return cell;
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  VideoListCell *videoListCell = (VideoListCell *)cell;
  NSInteger page = indexPath.row / ET_VIDEO_PER_PAGE + 1;
  NSInteger offset = indexPath.row % ET_VIDEO_PER_PAGE;
  VideoModel *videoModel =
      _manager.allVideos[_optionModel.category][@(page)][offset];
  [videoListCell setupWithVideoModel:videoModel];
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSInteger page = indexPath.row / ET_VIDEO_PER_PAGE + 1;
  NSInteger offset = indexPath.row % ET_VIDEO_PER_PAGE;
  VideoModel *videoModel =
      _manager.allVideos[_optionModel.category][@(page)][offset];
  VideoDetailController *videoDetailController =
      [[VideoDetailController alloc] init];
  videoDetailController.videoModel = videoModel;
  [self.navigationController pushViewController:videoDetailController
                                       animated:YES];
}

@end
