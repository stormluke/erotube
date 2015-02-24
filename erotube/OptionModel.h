//
//  OptionModel.h
//  erotube
//
//  Created by stormluke on 2/21/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionModel : NSObject

@property(nonatomic, strong) NSString *category;
@property(nonatomic) NSInteger mosaiced;
@property(nonatomic) NSInteger date;
@property(nonatomic) NSInteger sort;
@property(nonatomic) NSInteger duration;
@property(nonatomic, strong) NSArray *optionTitles;

- (NSInteger)optionsCount;
- (NSArray *)optionsForIndex:(NSInteger)index;
- (NSInteger)selectsForIndex:(NSInteger)index;
- (void)setSelectsForIndex:(NSInteger)index select:(NSInteger)select;
- (NSString *)buildParams;

@end
