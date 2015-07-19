//
//  Place.h
//  PlaceSearch
//
//  Created by Nicolas Martin on 7/5/12.
//  Copyright (c) 2012 University of Illinois at Urbana-Champaign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Information : NSObject {
    NSString *title;
    NSString *time;
    NSString *content;
    NSString *image;
    NSString *good;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *good;



+ (id)title:(NSString*)title time:(NSString*)time content:(NSString*)content image:(NSString*)image good:(NSString *)good;

@end