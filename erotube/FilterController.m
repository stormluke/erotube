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

@property(nonatomic, strong) DataManager *manager;
@property(nonatomic, strong) NSArray *optionNames;
@property(nonatomic, strong) NSMutableDictionary *options;
@property(nonatomic, strong) NSMutableDictionary *selects;

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

  _manager = [DataManager manager];
  _optionNames = @[ @"Category", @"Mosaiced", @"Date", @"Sort", @"Duration" ];
  _options = [NSMutableDictionary dictionaryWithDictionary:@{
    @"Category" : [[NSMutableArray alloc] init],
    @"Mosaiced" : @[ @"All", @"Yes", @"No" ],
    @"Date" : @[ @"Today", @"Week", @"Month", @"Half a Year", @"Year" ],
    @"Sort" : @[
      @"Date",
      @"Thumbs Up",
      @"Votes Ratio",
      @"Favourites",
      @"Views",
      @"Comment Counts"
    ],
    @"Duration" : @[ @"10 min", @"20 min", @"30 min", @"45 min", @"60 min" ]
  }];
  [_manager fetchCategoriesForce:NO].then(^{
    for (NSString *category in _manager.categories) {
      [_options[@"Category"]
          addObject:[NSString stringWithFormat:@"%@ / %@", category,
                                               _manager.categoryTranslations
                                                   [category]]];
    }
    [_tableView reloadData];
  });
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _optionNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  NSUInteger count = ((NSArray *)_options[_optionNames[section]]).count;
  if (count != 0) count++;
  return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [_tableView dequeueReusableCellWithIdentifier:@"OptionCell"
                                       forIndexPath:indexPath];
  NSArray *options = _options[_optionNames[indexPath.section]];
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
  NSString *optionName = _optionNames[section];

  NSNumber *select = _selects[optionName];
  if (!select) {
    select = @(0);
  }

  UITableViewCell<UIExpandingTableViewCell> *cell =
      [_tableView dequeueReusableCellWithIdentifier:@"FilterHeaderCell"];
  cell.textLabel.text = optionName;
  cell.detailTextLabel.text = _options[optionName][select.unsignedIntegerValue];
  return cell;
}

- (BOOL)tableView:(SLExpandableTableView *)tableView
    needsToDownloadDataForExpandableSection:(NSInteger)section {
  return NO;
}

- (void)tableView:(SLExpandableTableView *)tableView
    downloadDataForExpandableSection:(NSInteger)section {
}

@end
