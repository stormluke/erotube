//
//  CategoryController.m
//  erotube
//
//  Created by stormluke on 2/23/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "CategoryController.h"

#import "DataManager.h"
#import "FilterHeaderCell.h"

@interface CategoryController ()

@property(nonatomic, strong) DataManager *manager;

@end

@implementation CategoryController

- (void)viewDidLoad {
  [super viewDidLoad];

  _manager = [DataManager manager];
  [_tableView registerClass:[FilterHeaderCell class]
      forCellReuseIdentifier:@"CategoryCell"];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _manager.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [_tableView dequeueReusableCellWithIdentifier:@"CategoryCell"
                                       forIndexPath:indexPath];
  NSString *categoryName = _manager.categories[indexPath.row];
  NSString *category =
      [NSString stringWithFormat:@"%@ / %@", categoryName,
                                 _manager.categoryTranslations[categoryName]];
  NSString *count = [_manager.categoryCounts[categoryName] stringValue];
  cell.textLabel.text = category;
  cell.detailTextLabel.text = count;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

@end
