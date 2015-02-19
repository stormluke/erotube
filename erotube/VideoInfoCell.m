//
//  VideoInfoCell.m
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "VideoInfoCell.h"
#import "Utils.h"

#import <Haneke/Haneke.h>

@interface VideoInfoCell ()

@end

@implementation VideoInfoCell

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)setupWithVideoModel:(VideoModel *)videoModel {
  [Utils hostNameToIP:videoModel.imageURL].then(^(NSString *imageURL) {
    [_videoPreview hnk_setImageFromURL:[NSURL URLWithString:imageURL]
                           placeholder:[UIImage imageNamed:@"Placeholder"]];
  });
  _thumbUpLabel.text = [NSString stringWithFormat:@"%zd", videoModel.thumbUp];
  _thumbDownLabel.text =
      [NSString stringWithFormat:@"%zd", videoModel.thumbDown];
  _viewsLabel.text =
      videoModel.views >= 1000
          ? [NSString stringWithFormat:@"%zd K", videoModel.views / 1000]
          : [NSString stringWithFormat:@"%zd", videoModel.views];
  _durationLabel.text = videoModel.duration;
  _videoTitleLabel.text = videoModel.title;
  _descriptionLabel.text = videoModel.videoDescription;
}

@end
