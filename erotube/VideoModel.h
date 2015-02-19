//
//  VideoModel.h
//  erotube
//
//  Created by stormluke on 2/4/15.
//  Copyright (c) 2015 stormluke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* href;
@property(nonatomic, strong) NSString* imageURL;
@property(nonatomic) NSInteger thumbUp;
@property(nonatomic) NSInteger thumbDown;
@property(nonatomic, strong) NSString* duration;
@property(nonatomic) NSInteger views;
@property(nonatomic, strong) NSString* videoURL;
@property(nonatomic, strong) NSMutableArray* recommnadedVideos;
@property(nonatomic, strong) NSString* videoDescription;
@property(nonatomic, strong) NSString* date;

- (instancetype)initWithTitle:(NSString*)title
                         href:(NSString*)href
                     imageURL:(NSString*)imageURL
                      thumbUp:(NSInteger)thumbUp
                    thumbDown:(NSInteger)thumbDown
                     duration:(NSString*)duration
                         date:(NSString*)date;

@end
