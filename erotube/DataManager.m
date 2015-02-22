//
//  DataManager.m
//  erotube
//
//  Created by stormluke on 2/5/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "DataManager.h"
#import "VideoModel.h"
#import "Utils.h"

#import <AFNetworking/AFNetworking.h>
#import <HTMLReader/HTMLReader.h>

@interface DataManager ()

@property(nonatomic, strong) AFHTTPRequestOperationManager *requestManager;

@end

static NSString *ET_URL_EROVIDEO = @"http://209.54.49.203";

static DataManager *_manager = nil;

@implementation DataManager

+ (instancetype)manager {
  if (_manager == nil) {
    _manager = [[self alloc] init];
    _manager.requestManager = [AFHTTPRequestOperationManager manager];
    _manager.requestManager.responseSerializer =
        [AFHTTPResponseSerializer serializer];
    [_manager.requestManager.requestSerializer setValue:@"platform=mobile"
                                     forHTTPHeaderField:@"Cookie"];
    [_manager.requestManager.requestSerializer setValue:@"en-us"
                                     forHTTPHeaderField:@"Accept-Language"];
  }
  return _manager;
}

- (PMKPromise *)fetchCategoriesForce:(BOOL)force {
  return [PMKPromise new:^(PMKPromiseFulfiller fulfill,
                           PMKPromiseRejecter reject) {
    dispatch_promise(^{
      if (!force && _categories) {
        return fulfill(
            PMKManifold(_categories, _categoryCounts, _categoryHrefs));
      }
      NSMutableArray *categories = [[NSMutableArray alloc] init];
      [categories addObject:@"All"];
      [self GET:ET_URL_EROVIDEO
          parameters:nil].thenInBackground(^(HTMLDocument *document) {
        NSMutableDictionary *counts = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *hrefs = [[NSMutableDictionary alloc] init];
        [hrefs setObject:[NSString stringWithFormat:@"%@/?", ET_URL_EROVIDEO]
                  forKey:@"All"];
        [[[document firstNodeMatchingSelector:@"#sideCategories"]
            nodesMatchingSelector:@".item"]
            enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
              HTMLElement *elem = obj;
              NSString *href = elem.attributes[@"href"];
              NSString *category =
                  [elem firstNodeMatchingSelector:@".name"].textContent;
              NSNumber *count =
                  @([[[elem firstNodeMatchingSelector:@".count"].textContent
                      substringFromIndex:1] integerValue]);
              [categories addObject:category];
              counts[category] = count;
              hrefs[category] = href;
              _categories = categories;
              _categoryCounts = counts;
              _categoryHrefs = hrefs;
            }];
        [_manager.requestManager.requestSerializer setValue:@"ja-jp"
                                         forHTTPHeaderField:@"Accept-Language"];
        [self GET:ET_URL_EROVIDEO
            parameters:nil].thenInBackground(^(HTMLDocument *document) {
          NSMutableDictionary *categoryTranslations =
              [[NSMutableDictionary alloc] init];
          categoryTranslations[@"All"] = @"全部";
          [[[document firstNodeMatchingSelector:@"#sideCategories"]
              nodesMatchingSelector:@".item"]
              enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                HTMLElement *elem = obj;
                NSString *jpCategory =
                    [elem firstNodeMatchingSelector:@".name"].textContent;
                NSString *category = categories[idx + 1];
                categoryTranslations[category] = jpCategory;
              }];
          _categoryTranslations = categoryTranslations;
          [_manager.requestManager.requestSerializer
                        setValue:@"en-us"
              forHTTPHeaderField:@"Accept-Language"];
          return fulfill(PMKManifold(categories, counts, hrefs));
        });
      });
    });
  }];
}

- (PMKPromise *)fetchVideoListByCategory:(NSString *)category
                                    page:(NSInteger)page
                                   force:(BOOL)force {
  if (_allVideos == nil) {
    _allVideos = [[NSMutableDictionary alloc] init];
  }
  return [PMKPromise new:^(PMKPromiseFulfiller fulfill,
                           PMKPromiseRejecter reject) {
    assert([_categories containsObject:category]);
    dispatch_promise(^{
      if ([_allVideos objectForKey:category] == nil) {
        _allVideos[category] = [[NSMutableDictionary alloc] init];
      }
      NSMutableDictionary *videosByCategory = _allVideos[category];
      if (!force && [videosByCategory objectForKey:@(page)]) {
        return fulfill(PMKManifold(videosByCategory, _allVideos));
      }
      NSString *href = [category isEqualToString:@"All"]
                           ? @"http://ero-video.net"
                           : _categoryHrefs[category];
      [self GET:href
          parameters:nil].thenInBackground(^(HTMLDocument *document) {
        NSMutableArray *videos = [[NSMutableArray alloc] init];
        [[[document firstNodeMatchingSelector:@".movies"]
            nodesMatchingSelector:@".da-zoom-normal"]
            enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
              VideoModel *video = [self parseVideoInfo:obj];
              [videos addObject:video];
            }];
        videosByCategory[@(page)] = videos;
        return fulfill(PMKManifold(videosByCategory, _allVideos));
      });
    });
  }];
}

- (PMKPromise *)fetchVideoInfo:(VideoModel *)videoModel force:(BOOL)force {
  assert(videoModel.href);
  return [PMKPromise new:^(PMKPromiseFulfiller fulfill,
                           PMKPromiseRejecter reject) {
    if (!force && videoModel.videoURL) {
      return fulfill(videoModel);
    }
    [self GET:videoModel.href
        parameters:nil].thenInBackground(^(HTMLDocument *document) {
      videoModel.views =
          [[[document firstNodeMatchingSelector:@"#movie-views-counter"]
                  .textContent
              stringByReplacingOccurrencesOfString:@","
                                        withString:@""] integerValue];
      videoModel.videoURL =
          [document firstNodeMatchingSelector:@"video"].attributes[@"src"];
      videoModel.videoDescription =
          [document firstNodeMatchingSelector:@".description-text"].textContent;
      NSMutableArray *recommandedVideos = [[NSMutableArray alloc] init];
      [[[document firstNodeMatchingSelector:@".movies-vert"]
          nodesMatchingSelector:@".da-zoom-normal"]
          enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            VideoModel *video = [self parseVideoInfo:obj];
            if (![recommandedVideos containsObject:videoModel]) {
              [recommandedVideos addObject:video];
            }
          }];
      videoModel.recommnadedVideos = recommandedVideos;
      return fulfill(videoModel);
    });
  }];
}

- (PMKPromise *)GET:(NSString *)URLString parameters:(id)parameters {
  return [PMKPromise
      new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [Utils hostNameToIP:URLString].then(^(NSString *convertedURLString) {
          [_requestManager GET:convertedURLString
              parameters:parameters
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *html =
                    [[NSString alloc] initWithData:responseObject
                                          encoding:NSUTF8StringEncoding];
                HTMLDocument *document = [HTMLDocument documentWithString:html];
                return fulfill(document);
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                return reject(error);
              }];
        });
      }];
}

- (VideoModel *)parseVideoInfo:(HTMLElement *)elem {
  NSString *href =
      [elem firstNodeMatchingSelector:@".photo"].attributes[@"href"];
  NSString *imgURL = [elem firstNodeMatchingSelector:@"img"].attributes[@"src"];
  NSInteger thumbUp =
      [elem firstNodeMatchingSelector:@".up"].textContent.integerValue;
  NSInteger thumbDown =
      [elem firstNodeMatchingSelector:@".down"].textContent.integerValue;
  NSString *duration = [elem firstNodeMatchingSelector:@".time"].textContent;
  NSString *title = [elem firstNodeMatchingSelector:@".title"].textContent;
  NSString *date = [elem firstNodeMatchingSelector:@".date"].textContent;
  VideoModel *video = [[VideoModel alloc] initWithTitle:title
                                                   href:href
                                               imageURL:imgURL
                                                thumbUp:thumbUp
                                              thumbDown:thumbDown
                                               duration:duration
                                                   date:date];
  return video;
}

@end
