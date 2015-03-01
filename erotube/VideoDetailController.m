//
//  VideoDetailController.m
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "VideoDetailController.h"
#import "VideoListCell.h"
#import "VideoInfoCell.h"
#import "VideoListHeader.h"
#import "DataManager.h"
#import "Utils.h"
#import "VideoController.h"

#import <MediaPlayer/MediaPlayer.h>
#import <SVPullToRefresh/SVPullToRefresh.h>

typedef NS_ENUM(NSInteger, ETVideoDetailControllerState) {
  ETVideoDetailControllerStateNormal,
  ETVideoDetailControllerStateUpdating,
  ETVideoDetailControllerStatePrepare
};

@interface VideoDetailController ()

@property(nonatomic, strong) DataManager *manager;
@property(nonatomic) NSInteger state;

@end

@implementation VideoDetailController

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _manager = [DataManager manager];
  }
  return self;
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
  [super didMoveToParentViewController:parent];
  if (_tableView.pullToRefreshView == nil) {
    __weak VideoDetailController *self_ = self;
    [_tableView addPullToRefreshWithActionHandler:^{
      [self_ refreshData];
    }];
    [_tableView triggerPullToRefresh];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow
                            animated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [_tableView registerNib:[UINib nibWithNibName:@"VideoInfoCell" bundle:nil]
      forCellReuseIdentifier:@"VideoInfoCell"];
  [_tableView registerNib:[UINib nibWithNibName:@"VideoListCell" bundle:nil]
      forCellReuseIdentifier:@"VideoListCell"];
  [_tableView registerNib:[UINib nibWithNibName:@"VideoListHeader" bundle:nil]
      forHeaderFooterViewReuseIdentifier:@"VideoListHeader"];

  self.title = @"Video";
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return 1;
      break;
    default:
      return _videoModel.recommnadedVideos.count;
      break;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0: {
      VideoInfoCell *cell =
          [tableView dequeueReusableCellWithIdentifier:@"VideoInfoCell"
                                          forIndexPath:indexPath];
      return cell;
      break;
    }
    default: {
      VideoListCell *cell =
          [tableView dequeueReusableCellWithIdentifier:@"VideoListCell"
                                          forIndexPath:indexPath];
      return cell;
      break;
    }
  }
}

- (void)tableView:(UITableView *)tableView
      willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0: {
      VideoInfoCell *videoInfoCell = (VideoInfoCell *)cell;
      [videoInfoCell setupWithVideoModel:_videoModel];
      [videoInfoCell.playButton addTarget:self
                                   action:@selector(onPlayButtonClick)
                         forControlEvents:UIControlEventTouchUpInside];
      break;
    }
    default: {
      VideoListCell *videoListCell = (VideoListCell *)cell;
      [videoListCell
          setupWithVideoModel:_videoModel.recommnadedVideos[indexPath.row]];
      break;
    }
  }
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return nil;
      break;
    default: {
      VideoListHeader *header = [tableView
          dequeueReusableHeaderFooterViewWithIdentifier:@"VideoListHeader"];
      return header;
      break;
    }
  }
}

- (void)tableView:(UITableView *)tableView
    willDisplayHeaderView:(UIView *)view
               forSection:(NSInteger)section {
  switch (section) {
    case 0:
      break;
    default: {
      VideoListHeader *header = (VideoListHeader *)view;
      header.categoryLabel.text = @"Recommanded";
      break;
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0:
      return 352;
      break;
    default:
      return 104;
      break;
  }
}

- (NSIndexPath *)tableView:(UITableView *)tableView
    willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  switch (indexPath.section) {
    case 0:
      return nil;
      break;
    default:
      return indexPath;
      break;
  }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  switch (section) {
    case 0:
      return CGFLOAT_MIN;
      break;
    default:
      return 32;
      break;
  }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  VideoModel *videoModel = _videoModel.recommnadedVideos[indexPath.row];
  VideoDetailController *videoDetailController =
      [[VideoDetailController alloc] init];
  videoDetailController.videoModel = videoModel;
  [self.navigationController pushViewController:videoDetailController
                                       animated:YES];
}

- (void)setVideoModel:(VideoModel *)videoModel {
  _videoModel = videoModel;
  [self refreshData];
}

- (void)refreshData {
  [_manager fetchVideoInfo:_videoModel force:YES].then(
      ^(VideoModel *videoModel) {
        _videoModel = videoModel;
        [_tableView.pullToRefreshView stopAnimating];
        [_tableView reloadData];
      });
}

- (void)onPlayButtonClick {
  if (_state != ETVideoDetailControllerStatePrepare) {
    _state = ETVideoDetailControllerStatePrepare;
    [Utils hostNameToIP:_videoModel.videoURL].then(^(NSString *videoURLString) {
      _state = ETVideoDetailControllerStateNormal;
      NSURL *videoURL = [NSURL URLWithString:videoURLString];
      VideoController *videoController =
          [[VideoController alloc] initWithContentURL:videoURL];
      [self.navigationController
          presentMoviePlayerViewControllerAnimated:videoController];
    });
  }
}

@end
