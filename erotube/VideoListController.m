//
//  VideoListController.m
//  erotube
//
//  Created by stormluke on 2/24/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "VideoListController.h"
#import "DataManager.h"

@interface VideoListController ()

@property(nonatomic, strong) DataManager *manager;
@property(nonatomic) NSInteger length;

@end

@implementation VideoListController

- (void)viewDidLoad {
  [super viewDidLoad];
  _manager = [DataManager manager];
  _length = 0;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _length;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

@end
