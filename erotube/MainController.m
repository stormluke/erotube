//
//  MainController.m
//  erotube
//
//  Created by stormluke on 2/28/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "MainController.h"

#import "HomeController.h"
#import "CategoryController.h"

@interface MainController ()

@property(nonatomic, strong) HomeController *homeController;
@property(nonatomic, strong) CategoryController *categoryController;

@end

@implementation MainController

- (void)loadView {
  [super loadView];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _homeController = [[HomeController alloc] init];
  _categoryController = [[CategoryController alloc] init];
  UINavigationController *navHome = [[UINavigationController alloc]
      initWithRootViewController:_homeController];
  UINavigationController *navCategory = [[UINavigationController alloc]
      initWithRootViewController:_categoryController];
  UITabBarItem *itemHome = [[UITabBarItem alloc]
      initWithTabBarSystemItem:UITabBarSystemItemMostRecent
                           tag:0];
  navHome.tabBarItem = itemHome;
  UITabBarItem *itemCategory =
      [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch
                                                 tag:1];
  navCategory.tabBarItem = itemCategory;

  [self setViewControllers:@[ navHome, navCategory ] animated:YES];
  [self setSelectedViewController:navHome];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
