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
    NSString *tags;
    NSString *time;
    NSString *x;
    NSString *y;
    NSString *content;
    NSString *image;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *image;



+ (id)title:(NSString*)title tags:(NSString*)tags time:(NSString*)time x:(NSString*)x y:(NSString*)y content:(NSString*)content image:(NSString*)image;

@end