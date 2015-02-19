//
//  FilterController.m
//  erotube
//
//  Created by stormluke on 2/9/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "FilterController.h"
#import "FilterHeaderCell.h"

@interface FilterController ()

@end

@implementation FilterController

- (void)loadView {
  _tableView =
      [[SLExpandableTableView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                             style:UITableViewStylePlain];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view = _tableView;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_tableView registerNib:[UINib nibWithNibName:@"VideoListCell" bundle:nil]
      forCellReuseIdentifier:@"VideoListCell"];
  [_tableView registerClass:[FilterHeaderCell class]
      forCellReuseIdentifier:@"FilterHeaderCell"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"Cell");
  return [_tableView dequeueReusableCellWithIdentifier:@"VideoListCell"
                                          forIndexPath:indexPath];
}

- (BOOL)tableView:(SLExpandableTableView *)tableView
    canExpandSection:(NSInteger)section {
  return YES;
}

- (UITableViewCell<UIExpandingTableViewCell> *)
                  tableView:(SLExpandableTableView *)tableView
    expandingCellForSection:(NSInteger)section {
  NSLog(@"expanding %zd", section);
  UITableViewCell<UIExpandingTableViewCell> *c =
      [_tableView dequeueReusableCellWithIdentifier:@"FilterHeaderCell"];
  c.textLabel.text = @"OH";
  return c;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView
    needsToDownloadDataForExpandableSection:(NSInteger)section {
  return NO;
}

- (void)tableView:(SLExpandableTableView *)tableView
    downloadDataForExpandableSection:(NSInteger)section {
}

@end
