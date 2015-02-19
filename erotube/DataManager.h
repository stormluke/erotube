//
//  DataManager.h
//  erotube
//
//  Created by stormluke on 2/5/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "VideoModel.h"

#import <PromiseKit/PromiseKit.h>

@interface DataManager : NSObject

@property(nonatomic, strong) NSMutableArray *categories;
@property(nonatomic, strong) NSMutableDictionary *categoryCounts;
@property(nonatomic, strong) NSMutableDictionary *categoryHrefs;
@property(nonatomic, strong) NSMutableDictionary *categoryTranslations;
@property(nonatomic, strong) NSMutableDictionary *allVideos;

+ (instancetype)manager;
- (PMKPromise *)fetchCategoriesForce:(BOOL)force;
- (PMKPromise *)fetchVideoListByCategory:(NSString *)category
                                    page:(NSInteger)page
                                   force:(BOOL)force;
- (PMKPromise *)fetchVideoInfo:(VideoModel *)videoModel force:(BOOL)force;

@end
