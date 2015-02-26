//
//  OptionModel.h
//  erotube
//
//  Created by stormluke on 2/21/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ET_OPTION_MOSAICED) {
  ET_OPTION_MOSAICED_ALL,
  ET_OPTION_MOSAICED_YES,
  ET_OPTION_MOSAICED_NO
};

typedef NS_ENUM(NSInteger, ET_OPTION_DATE) {
  ET_OPTION_DATE_ALL,
  ET_OPTION_DATE_TODAY,
  ET_OPTION_DATE_WEEK,
  ET_OPTION_DATE_MONTH,
  ET_OPTION_DATE_HALFYEAR,
  ET_OPTION_DATE_YEAR
};

typedef NS_ENUM(NSInteger, ET_OPTION_SORT) {
  ET_OPTION_SORT_DATE,
  ET_OPTION_SORT_THUMBSUP,
  ET_OPTION_SORT_VOTESRATIO,
  ET_OPTION_SORT_FAVOURITES,
  ET_OPTION_SORT_VIEWS,
  ET_OPTION_SORT_COMMENTCOUNTS
};

typedef NS_ENUM(NSInteger, ET_OPTION_DURATION) {
  ET_OPTION_DURATION_ALL,
  ET_OPTION_DURATION_10,
  ET_OPTION_DURATION_20,
  ET_OPTION_DURATION_30,
  ET_OPTION_DURATION_45,
  ET_OPTION_DURATION_60
};

extern NSString *const ET_OPTIONS_CATEGORY;
extern NSString *const ET_OPTIONS_MOSAICED;
extern NSString *const ET_OPTIONS_DATE;
extern NSString *const ET_OPTIONS_SORT;
extern NSString *const ET_OPTIONS_DURATION;

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
