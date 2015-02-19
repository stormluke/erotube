//
//  VideoModel.m
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (BOOL)isEqual:(id)object {
  if (object == self) return YES;
  if (!object || ![object isKindOfClass:[self class]]) return NO;
  if ([((VideoModel *)object).href isEqualToString:_href]) return YES;
  return NO;
}

- (instancetype)initWithTitle:(NSString *)title
                         href:(NSString *)href
                     imageURL:(NSString *)imageURL
                      thumbUp:(NSInteger)thumbUp
                    thumbDown:(NSInteger)thumbDown
                     duration:(NSString *)duration
                         date:(NSString *)date {
  self = [self init];
  if (self) {
    _title = title;
    _href = href;
    _imageURL = imageURL;
    _thumbUp = thumbUp;
    _thumbDown = thumbDown;
    _duration = duration;
    _date = date;
  }
  return self;
}

- (NSMutableArray *)recommnadedVideos {
  if (_recommnadedVideos == nil) {
    _recommnadedVideos = [[NSMutableArray alloc] init];
  }
  return _recommnadedVideos;
}

- (NSString *)description {
  return [NSString
      stringWithFormat:@"title = %@, href = %@, imageURL = %@, "
                       @"thumbUp = %zd, thumbDown = %zd, "
                       @"duration = %@, views = %zd, videoURL = %@, "
                       @"recommandedVideos = %zd, description = %@, date = %@",
                       _title, _href, _imageURL, _thumbUp, _thumbDown,
                       _duration, _views, _videoURL, _recommnadedVideos.count,
                       _videoDescription, _date];
}

@end
