//
//  SUPlaceInfo.h
//  odds
//
//  Created by Chia-YangTsai on 2014/5/10.
//  Copyright (c) 2014年 SUshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>



@interface SUPlaceInfo : NSObject


@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *reference;

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;


- (id) initWithDescription:(NSString *)description;
+ (id) placeInfoWithDescription:(NSString *)description;


@end
