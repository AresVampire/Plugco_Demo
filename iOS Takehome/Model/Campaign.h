//
//  Campaign.h
//  iOS Takehome
//
//  Created by Yugene on 7/3/19.
//  Copyright © 2019 Real Labs Technology, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Campaign : NSObject

@property (nonatomic) NSString *iconUrl;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *payPerInstall;
@property (nonatomic) NSMutableArray *coverPhotoUrl;
@property (nonatomic) NSMutableArray *downloadUrl;
@property (nonatomic) NSMutableArray *mediaType;
@property (nonatomic) NSMutableArray *trackingLink;

- (id) init;

@end

NS_ASSUME_NONNULL_END
