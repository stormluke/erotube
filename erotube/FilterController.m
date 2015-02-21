//
//  FilterController.m
//  erotube
//
//  Created by stormluke on 2/9/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "FilterController.h"
#import "FilterHeaderCell.h"

#import "DataManager.h"

@interface FilterController ()

@property(nonatomic, strong) UITableView *tableView;

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
  [_tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:@"OptionCell"];
  [_tableView registerClass:[FilterHeaderCell class]
      forCellReuseIdentifier:@"FilterHeaderCell"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _optionModel.optionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  NSUInteger count = [_optionModel optionsForIndex:section].count;
  if (count != 0) count++;
  return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [_tableView dequeueReusableCellWithIdentifier:@"OptionCell"
                                       forIndexPath:indexPath];
  NSArray *options = [_optionModel optionsForIndex:indexPath.section];
  cell.textLabel.text = options[indexPath.row - 1];
  return cell;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView
    canExpandSection:(NSInteger)section {
  return YES;
}

- (UITableViewCell<UIExpandingTableViewCell> *)
                  tableView:(SLExpandableTableView *)tableView
    expandingCellForSection:(NSInteger)section {
  NSInteger select = [_optionModel selectsForIndex:section];

  UITableViewCell<UIExpandingTableViewCell> *cell =
      [_tableView dequeueReusableCellWithIdentifier:@"FilterHeaderCell"];
  cell.textLabel.text = _optionModel.optionTitles[section];
  cell.detailTextLabel.text = [_optionModel optionsForIndex:section][select];
  return cell;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView
    needsToDownloadDataForExpandableSection:(NSInteger)section {
  return NO;
}

- (void)tableView:(SLExpandableTableView *)tableView
    downloadDataForExpandableSection:(NSInteger)section {
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [_optionModel setSelectsForIndex:indexPath.section select:indexPath.row - 1];
  NSIndexPath *sectionIndex =
      [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
  UITableViewCell<UIExpandingTableViewCell> *cell =
      (UITableViewCell<UIExpandingTableViewCell> *)
          [_tableView cellForRowAtIndexPath:sectionIndex];
  cell.detailTextLabel.text =
      [_optionModel optionsForIndex:indexPath.section][indexPath.row - 1];
  [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
