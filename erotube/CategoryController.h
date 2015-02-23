//
//  CategoryController.h
//  erotube
//
//  Created by stormluke on 2/23/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryController
    : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end
