//
//  FilterHeaderCell.h
//  erotube
//
//  Created by stormluke on 2/9/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <SLExpandableTableView/SLExpandableTableView.h>

@interface FilterHeaderCell : UITableViewCell<UIExpandingTableViewCell>

@property(nonatomic, getter=isLoading) BOOL loading;
@property(nonatomic) UIExpansionStyle expansionStyle;

@end
