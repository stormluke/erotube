//
//  Utils.h
//  erotube
//
//  Created by stormluke on 2/6/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>

@interface Utils : NSObject

+ (PMKPromise *)lookupHostName:(NSString *)hostName;
+ (PMKPromise *)hostNameToIP:(NSString *)originalURL;

@end
