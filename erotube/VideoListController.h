//
//  VideoListController.h
//  erotube
//
//  Created by stormluke on 2/24/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OptionModel.h"
#import "FilterController.h"

@interface VideoListController
    : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) OptionModel *optionModel;
@property(nonatomic, strong) FilterController *filterController;

@end
