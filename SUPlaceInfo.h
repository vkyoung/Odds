//
//  SUPlaceInfo.h
//  odds
//
//  Created by Chia-YangTsai on 2014/5/10.
//  Copyright (c) 2014年 SUshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUPlaceInfo : NSObject


@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *reference;


- (id) initWithDescription:(NSString *)description;
+ (id) placeInfoWithDescription:(NSString *)description;


@end
