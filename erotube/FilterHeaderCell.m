//
//  FilterHeaderCell.m
//  erotube
//
//  Created by stormluke on 2/9/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "FilterHeaderCell.h"

@implementation FilterHeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  return [super initWithStyle:UITableViewCellStyleValue1
              reuseIdentifier:reuseIdentifier];
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)setExpansionStyle:(UIExpansionStyle)style animated:(BOOL)animated {
}

@end
