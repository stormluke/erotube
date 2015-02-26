//
//  OptionModel.m
//  erotube
//
//  Created by stormluke on 2/21/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "OptionModel.h"
#import "DataManager.h"

NSString *const ET_OPTIONS_CATEGORY = @"Category";
NSString *const ET_OPTIONS_MOSAICED = @"Mosaiced";
NSString *const ET_OPTIONS_DATE = @"Date";
NSString *const ET_OPTIONS_SORT = @"Sort By";
NSString *const ET_OPTIONS_DURATION = @"Duration";

typedef NS_ENUM(NSInteger, ETOptionsIndex) {
  ETOptionsIndexCategory,
  ETOptionsIndexMosaiced,
  ETOptionsIndexDate,
  ETOptionsIndexSort,
  ETOptionsIndexDuration
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
    _category = @"All";
    _optionTitles = @[
      ET_OPTIONS_CATEGORY,
      ET_OPTIONS_MOSAICED,
      ET_OPTIONS_DATE,
      ET_OPTIONS_SORT,
      ET_OPTIONS_DURATION
    ];
    _manager = [DataManager manager];
    NSMutableArray *categoryNames = [[NSMutableArray alloc] init];
    for (NSString *category in _manager.categories) {
      [categoryNames
          addObject:[NSString stringWithFormat:@"%@ / %@", category,
                                               _manager.categoryTranslations
                                                   [category]]];
    }
    _optionNames = [[NSMutableDictionary alloc] initWithDictionary:@{
      ET_OPTIONS_CATEGORY : categoryNames,
      ET_OPTIONS_MOSAICED : @[ @"All", @"Yes", @"No" ],
      ET_OPTIONS_DATE : @[
        @"All",
        @"Today",
        @"≤ a Week",
        @"≤ a Month",
        @"≤ Half a Year",
        @"≤ a Year"
      ],
      ET_OPTIONS_SORT : @[
        @"Date",
        @"Thumbs Up",
        @"Votes Ratio",
        @"Favorites",
        @"Views",
        @"Comment Counts"
      ],
      ET_OPTIONS_DURATION : @[
        @"All",
        @"≥ 10 min",
        @"≥ 20 min",
        @"≥ 30 min",
        @"≥ 45 min",
        @"≥ 60 min"
      ]
    }];
    _optionValues = [[NSMutableDictionary alloc] initWithDictionary:@{
      ET_OPTIONS_MOSAICED : @[ @"", @"1", @"2" ],
      ET_OPTIONS_DATE :
          @[ @"", @"today", @"week", @"month", @"halfyear", @"year" ],
      ET_OPTIONS_DATE : @[
        @"",
        @"votes",
        @"votes_ratio",
        @"favorites",
        @"movie_view",
        @"comment_count"
      ],
      ET_OPTIONS_DURATION : @[ @"", @"10", @"20", @"30", @"45", @"60" ]
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
    case ETOptionsIndexCategory: {
      NSInteger select =
          [_optionNames[ET_OPTIONS_CATEGORY] indexOfObject:_category];
      if (select != NSNotFound) {
        return select;
      }
      return 0;
      break;
    }
    case ETOptionsIndexMosaiced:
      return _mosaiced;
      break;
    case ETOptionsIndexDate:
      return _date;
      break;
    case ETOptionsIndexSort:
      return _sort;
      break;
    case ETOptionsIndexDuration:
      return _duration;
      break;
    default:
      return -1;
      break;
  }
}

- (void)setSelectsForIndex:(NSInteger)index select:(NSInteger)select {
  switch (index) {
    case ETOptionsIndexCategory:
      _category = [_manager.categories objectAtIndex:select];
      break;
    case ETOptionsIndexMosaiced:
      _mosaiced = select;
      break;
    case ETOptionsIndexDate:
      _date = select;
      break;
    case ETOptionsIndexSort:
      _sort = select;
      break;
    case ETOptionsIndexDuration:
      _duration = select;
      break;
    default:
      break;
  }
}

- (NSString *)buildParams {
  return [NSString
      stringWithFormat:@"&mosaiced=%@&age=%@&sort=%@&minimumLength=%@",
                       _optionValues[ET_OPTIONS_MOSAICED][_mosaiced],
                       _optionValues[ET_OPTIONS_DATE][_date],
                       _optionValues[ET_OPTIONS_SORT][_sort],
                       _optionValues[ET_OPTIONS_DURATION][_duration]];
}

- (NSString *)description {
  return
      [NSString stringWithFormat:@"category = %@, mosaiced = %zd, date = %zd, "
                                 @"sort = %zd, duration = %zd",
                                 _category, _mosaiced, _date, _sort, _duration];
}

@end
