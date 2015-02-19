//
//  VideoListCell.m
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "VideoListCell.h"
#import "Utils.h"

#import <Haneke/Haneke.h>

@implementation VideoListCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)setupWithVideoModel:(VideoModel *)videoModel {
  _videoTitleLabel.text = videoModel.title;
  _durationLabel.text = videoModel.duration;
  NSString *thumbUp =
      videoModel.thumbUp >= 1000
          ? [NSString stringWithFormat:@"%zd K", videoModel.thumbUp / 1000]
          : videoModel.thumbUp == 0 && videoModel.thumbDown == 0
                ? @"-"
                : [NSString stringWithFormat:@"%zd", videoModel.thumbUp];
  NSString *voteRatio =
      videoModel.thumbDown == 0 && videoModel.thumbUp == 0
          ? @""
          : [NSString stringWithFormat:@" / %zd%%",
                                       (NSInteger)(videoModel.thumbUp * 100.0 /
                                                   (videoModel.thumbUp +
                                                    videoModel.thumbDown))];
  _votesLabel.text = [thumbUp stringByAppendingString:voteRatio];
  _dateLabel.text = videoModel.date;
  [Utils hostNameToIP:videoModel.imageURL].then(^(NSString *imageURL) {
    [_videoPreview hnk_setImageFromURL:[NSURL URLWithString:imageURL]
                           placeholder:[UIImage imageNamed:@"Placeholder"]];
  });
}

@end
