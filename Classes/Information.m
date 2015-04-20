//
//  Place.m
//  PlaceSearch
//
//  Created by Nicolas Martin on 7/5/12.
//  Copyright (c) 2012 University of Illinois at Urbana-Champaign. All rights reserved.
//

#import "Information.h"

@implementation Information
@synthesize title, tags, time, x, y, content, image;

+(id)title:(NSString *)title tags:(NSString *)tags time:(NSString *)time x:(NSString *)x y:(NSString *)y content:(NSString *)content image:(NSString *)image
{
    Information *info = [[self alloc] init];
    [info setTitle:title];
    [info setTags:tags];
    [info setTime:time];
    [info setX:x];
    [info setY:y];
    [info setContent:content];
    [info setImage:image];
    return info;
}

@end