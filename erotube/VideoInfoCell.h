//
//  VideoInfoCell.h
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

@interface VideoInfoCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *videoPreview;
@property(nonatomic, strong) IBOutlet UILabel *thumbUpLabel;
@property(nonatomic, strong) IBOutlet UILabel *thumbDownLabel;
@property(nonatomic, strong) IBOutlet UILabel *viewsLabel;
@property(nonatomic, strong) IBOutlet UILabel *durationLabel;
@property(nonatomic, strong) IBOutlet UILabel *videoTitleLabel;
@property(nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property(strong, nonatomic) IBOutlet UIButton *playButton;

- (void)setupWithVideoModel:(VideoModel *)videoModel;

@end
