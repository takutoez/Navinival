//
//  AppDelegate.h
//  TestProject
//
//  Created by 六車卓土 on 2015/01/03.
//  Copyright (c) 2015年 takutoez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *baseUrl;
@property (strong, nonatomic) NSMutableArray *mapArray;
@property (strong, nonatomic) NSMutableArray *beaconArray;
@property (strong, nonatomic) UIVisualEffectView *mapInformationView;

- (void)changeStory:(int)floor;
- (void)mapDataX:(int)x withY:(int)y withFloor:(int)floor;

@end