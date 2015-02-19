//
//  VideoListHeader.h
//  erotube
//
//  Created by stormluke on 2/6/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListHeader : UITableViewHeaderFooterView

@property(nonatomic, strong) IBOutlet UILabel *categoryLabel;
@property(nonatomic, strong) IBOutlet UIButton *moreButton;

@end
