//
//  HomeController.h
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeController
    : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *videoTableView;

@end
