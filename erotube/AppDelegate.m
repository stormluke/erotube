//
//  AppDelegate.m
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController.h"
#import "FilterController.h"
#import "CategoryController.h"
#import "VideoListController.h"

#import "DataManager.h"
#import "Utils.h"
#import "OptionModel.h"

#import <MMDrawerController/MMDrawerController.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [[DataManager manager] fetchCategoriesForce:YES].then(^() {
    FilterController *fc = [[FilterController alloc] init];
    OptionModel *o = [[OptionModel alloc] init];
    o.category = @"All";
    fc.optionModel = o;

    UINavigationController *nfc =
        [[UINavigationController alloc] initWithRootViewController:fc];

    VideoListController *vc = [[VideoListController alloc] init];
    vc.optionModel = o;

    vc.filterController = fc;

    //  HomeController *homeController = [[HomeController alloc] init];

    //    CategoryController *c = [[CategoryController alloc] init];

    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:vc];

    MMDrawerController *dc = [[MMDrawerController alloc]
        initWithCenterViewController:navigationController
           rightDrawerViewController:nfc];
    [dc setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [dc setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = dc;

    [self.window makeKeyAndVisible];
    //    NSLog(@"%@", [o buildParams]);
  });

  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

@end
