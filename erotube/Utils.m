//
//  Utils.m
//  erotube
//
//  Created by stormluke on 2/6/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import "Utils.h"

#import <netdb.h>
#import <arpa/inet.h>

@interface Utils ()

@end

static Utils *_utils = nil;
static NSString *_pattern = @"://([^:/]+)";
static NSMutableDictionary *_hostNameIPs = nil;

@implementation Utils

+ (instancetype)utils {
  if (_utils == nil) {
    _utils = [[self alloc] init];
    _hostNameIPs = [[NSMutableDictionary alloc] init];
  }
  return _utils;
}

+ (PMKPromise *)lookupHostName:(NSString *)hostName {
  return [PMKPromise
      new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        __block BOOL isFulfilled = NO;
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC),
            dispatch_get_main_queue(), ^{
              if (!isFulfilled) {
                NSError *error =
                    [NSError errorWithDomain:@"erotube" code:0 userInfo:nil];
                return reject(error);
              }
            });
        if (_hostNameIPs[hostName]) {
          return fulfill(_hostNameIPs[hostName]);
        }
        dispatch_promise(^{
          struct hostent *remoteHostEnt = gethostbyname([hostName UTF8String]);
          struct in_addr *remoteInAddr =
              (struct in_addr *)remoteHostEnt->h_addr_list[0];
          char *sRemoteInAddr = inet_ntoa(*remoteInAddr);
          NSString *hostIP = [NSString stringWithUTF8String:sRemoteInAddr];
          _hostNameIPs[hostName] = hostIP;
          isFulfilled = YES;
          return fulfill(hostIP);
        });
      }];
}

+ (PMKPromise *)hostNameToIP:(NSString *)originalURL {
  return [PMKPromise
      new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        if (originalURL == nil) return fulfill(nil);
        NSRegularExpression *regex =
            [NSRegularExpression regularExpressionWithPattern:_pattern
                                                      options:0
                                                        error:nil];
        NSTextCheckingResult *match =
            [regex firstMatchInString:originalURL
                              options:0
                                range:NSMakeRange(0, originalURL.length)];
        NSString *hostName =
            [originalURL substringWithRange:[match rangeAtIndex:1]];
        [self lookupHostName:hostName].thenInBackground(^(NSString *hostIP) {
          NSString *result =
              [originalURL stringByReplacingOccurrencesOfString:hostName
                                                     withString:hostIP];
          fulfill(result);
        });
      }];
}

@end
