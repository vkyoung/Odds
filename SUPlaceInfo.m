//
//  SUPlaceInfo.m
//  odds
//
//  Created by Chia-YangTsai on 2014/5/10.
//  Copyright (c) 2014年 SUshi. All rights reserved.
//

#import "SUPlaceInfo.h"


@implementation SUPlaceInfo


- (id) initWithDescription:(NSString *)description
{
    self = [super init];
    
    if( self ) {
        self.description = description;
        self.reference = nil;
    }
    
    return self;
}



+ (id) placeInfoWithDescription:(NSString *) description
{
    return [[self alloc] initWithDescription:description];
}



@end
