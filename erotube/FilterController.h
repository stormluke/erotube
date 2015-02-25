//
//  FilterController.h
//  erotube
//
//  Created by stormluke on 2/9/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OptionModel.h"

#import <SLExpandableTableView/SLExpandableTableView.h>

@interface FilterController : UIViewController<SLExpandableTableViewDatasource,
                                               SLExpandableTableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic, strong) OptionModel *optionModel;

@property(nonatomic, strong) void (^didChangeOption)(OptionModel *optionModel);

@end
