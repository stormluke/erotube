//
//  VideoListCell.h
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoListCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *videoPreview;
@property(nonatomic, strong) IBOutlet UILabel *videoTitleLabel;
@property(nonatomic, strong) IBOutlet UILabel *durationLabel;
@property(nonatomic, strong) IBOutlet UILabel *votesLabel;
@property(nonatomic, strong) IBOutlet UILabel *dateLabel;

- (void)setupWithVideoModel:(VideoModel *)videoModel;

@end
