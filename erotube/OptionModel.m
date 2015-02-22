//
//  OptionModel.m
//  erotube
//
//  Created by stormluke on 2/21/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "OptionModel.h"
#import "DataManager.h"

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

@interface OptionModel ()

@property(nonatomic, strong) DataManager *manager;
@property(nonatomic, strong) NSMutableDictionary *optionNames;
@property(nonatomic, strong) NSMutableDictionary *optionValues;

@end

@implementation OptionModel

- (instancetype)init {
  self = [super init];
  if (self) {
    _optionTitles =
        @[ @"Category", @"Mosaiced", @"Date", @"Sort", @"Duration" ];
    _manager = [DataManager manager];
    NSMutableArray *categoryNames = [[NSMutableArray alloc] init];
    for (NSString *category in _manager.categories) {
      [categoryNames
          addObject:[NSString stringWithFormat:@"%@ / %@", category,
                                               _manager.categoryTranslations
                                                   [category]]];
    }
    _optionNames = [[NSMutableDictionary alloc] initWithDictionary:@{
      @"Category" : categoryNames,
      @"Mosaiced" : @[ @"All", @"Yes", @"No" ],
      @"Date" : @[
        @"All",
        @"Today",
        @"≤ a Week",
        @"≤ a Month",
        @"≤ Half a Year",
        @"≤ a Year"
      ],
      @"Sort" : @[
        @"Date",
        @"Thumbs Up",
        @"Votes Ratio",
        @"Favorites",
        @"Views",
        @"Comment Counts"
      ],
      @"Duration" : @[
        @"All",
        @"≤ 10 min",
        @"≤ 20 min",
        @"≤ 30 min",
        @"≤ 45 min",
        @"≤ 60 min"
      ]
    }];
    _optionValues = [[NSMutableDictionary alloc] initWithDictionary:@{
      @"Mosaiced" : @[ @"", @"1", @"2" ],
      @"Date" : @[ @"", @"today", @"week", @"month", @"halfyear", @"year" ],
      @"Sort" : @[
        @"",
        @"votes",
        @"votes_ratio",
        @"favorites",
        @"movie_view",
        @"comment_count"
      ],
      @"Duration" : @[ @"", @"10", @"20", @"30", @"45", @"60" ]
    }];
  }
  return self;
}

- (NSInteger)optionsCount {
  return _optionNames.count;
}

- (NSArray *)optionsForIndex:(NSInteger)index {
  return _optionNames[_optionTitles[index]];
}

- (NSInteger)selectsForIndex:(NSInteger)index {
  switch (index) {
    case 0: {
      NSInteger select = [_optionNames[@"Category"] indexOfObject:_category];
      if (select != NSNotFound) {
        return select;
      }
      return 0;
      break;
    }
    case 1:
      return _mosaiced;
      break;
    case 2:
      return _date;
      break;
    case 3:
      return _sort;
      break;
    case 4:
      return _duration;
      break;
    default:
      return -1;
      break;
  }
}

- (void)setSelectsForIndex:(NSInteger)index select:(NSInteger)select {
  switch (index) {
    case 0:
      _category = [_optionNames[@"Category"] objectAtIndex:select];
      break;
    case 1:
      _mosaiced = select;
      break;
    case 2:
      _date = select;
      break;
    case 3:
      _sort = select;
      break;
    case 4:
      _duration = select;
      break;
    default:
      break;
  }
}

- (NSString *)constructURL {
  return [NSString
      stringWithFormat:@"%@&mosaiced=%@&age=%@&sort=%@&minimumLength=%@",
                       _manager.categoryHrefs[_category],
                       _optionValues[@"Mosaiced"][_mosaiced],
                       _optionValues[@"Date"][_date],
                       _optionValues[@"Sort"][_sort],
                       _optionValues[@"Duration"][_duration]];
}

@end
