//
//  Place.m
//  PlaceSearch
//
//  Created by Nicolas Martin on 7/5/12.
//  Copyright (c) 2012 University of Illinois at Urbana-Champaign. All rights reserved.
//

#import "Information.h"

@implementation Information

+(id)title:(NSString *)_title time:(NSString *)_time content:(NSString *)_content image:(NSString *)_image
{
    Information *info = [[self alloc] init];
    [info setTitle:_title];
    [info setTime:_time];
    [info setContent:_content];
    [info setImage:_image];
    return info;
}

@end