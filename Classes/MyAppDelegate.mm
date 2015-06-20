//
//  AppDelegate.m
//  TestProject
//
//  Created by 六車卓土 on 2015/01/03.
//  Copyright (c) 2015年 takutoez. All rights reserved.
//

#import "MyAppDelegate.h"
#import <Parse/Parse.h>

@interface MyAppDelegate ()

@end

@implementation MyAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _baseUrl = @"http://126.217.92.188:8080";
    
    [Parse setApplicationId:@"ERYPrORJqGmfiaQN66gNPCyhX30i9ZtMnRMf2BeS"
                  clientKey:@"zbFmvecCs7LoqXRJ1bZNpSVH8yX9oKmposYb9GTn"];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//バッジを消す
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    [[delegateFreeSession dataTaskWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/map/data/", BASE_URL]]
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (error != nil){
                                NSLog(@"Got response %@ with error %@.\n", response, error);
                            }else{
                                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                _mapArray = [NSMutableArray array];
                                for (NSDictionary *jsonDictionary in jsonArray)
                                {
                                    [_mapArray addObject:jsonDictionary];
                                }
                            }
                        }] resume];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;//バッジを消す
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)mapInformation:(CGPoint)point number:(NSInteger)number upperLeftX:(double)upperLeftX upperLeftY:(double)upperLeftY lowerLeftX:(double)lowerLeftX lowerLeftY:(double)lowerLeftY upperRightX:(double)upperRightX upperRightY:(double)upperRightY lowerRightX:(double)lowerRightX lowerRightY:(double)lowerRightY{
    
    CGVector upper      = CGVectorMake(upperRightX - upperLeftX, upperRightY - upperLeftY);
    CGVector left       = CGVectorMake(upperLeftX - lowerLeftX, upperLeftX - lowerLeftY);
    CGVector lower      = CGVectorMake(lowerLeftX - lowerRightY, lowerLeftY - lowerRightY);
    CGVector right      = CGVectorMake(lowerRightX - upperRightX, lowerRightY - upperRightY);
    CGVector upperLeft  = CGVectorMake(point.x - upperLeftX, point.y - upperLeftY);
    CGVector lowerLeft  = CGVectorMake(point.x - lowerLeftX, point.y - lowerLeftY);
    CGVector upperRight = CGVectorMake(point.x - upperRightX, point.y - upperRightY);
    CGVector lowerRight = CGVectorMake(point.x - lowerRightX, point.y - lowerRightY);
    
    double c1 = upper.dx * upperRight.dy - upper.dy * upperRight.dx;
    double c2 = left.dx * upperLeft.dy - left.dy * upperLeft.dx;
    double c3 = lower.dx * lowerLeft.dy - lower.dy * lowerLeft.dx;
    double c4 = right.dx * lowerRight.dy - right.dy * lowerRight.dx;
    
    if((c1 > 0 && c2 > 0 && c3 > 0 && c4 > 0) || (c1 < 0 && c2 < 0 && c3 < 0 && c4 < 0)){
        NSLog(@"OK");
    }
    
}

- (void)mapDataX:(int)x withY:(int)y withFloor:(int)floor{
    NSLog(@"%d, %d", x, y);
    CGPoint point = CGPointMake(x, y);
    switch(floor){
        case 1:
            [self mapInformation: point number:1 upperLeftX:2464.0 upperLeftY:4197.0 lowerLeftX:2464.0 lowerLeftY:4274.0 upperRightX:2570.0 upperRightY:4197.0 lowerRightX:2570.0 lowerRightY:4274.0];//文書保管庫
            [self mapInformation: point number:2 upperLeftX:2463.0 upperLeftY:4115.0 lowerLeftX:2464.0 lowerLeftY:4196.0 upperRightX:2569.0 upperRightY:4115.0 lowerRightX:2570.0 lowerRightY:4196.0];//作業室
            [self mapInformation: point number:3 upperLeftX:2464.0 upperLeftY:4054.0 lowerLeftX:2463.0 lowerLeftY:4114.0 upperRightX:2569.0 upperRightY:4053.0 lowerRightX:2569.0 lowerRightY:4115.0];//更衣室
            [self mapInformation: point number:4 upperLeftX:2463.0 upperLeftY:3785.0 lowerLeftX:2464.0 lowerLeftY:4053.0 upperRightX:2568.0 upperRightY:3786.0 lowerRightX:2568.0 lowerRightY:4053.0];//事務室
            [self mapInformation: point number:5 upperLeftX:2463.0 upperLeftY:3748.0 lowerLeftX:2464.0 lowerLeftY:3786.0 upperRightX:2568.0 upperRightY:3749.0 lowerRightX:2568.0 lowerRightY:3785.0];//守衛室
            [self mapInformation: point number:6 upperLeftX:2463.0 upperLeftY:3649.0 lowerLeftX:2463.0 lowerLeftY:3749.0 upperRightX:2568.0 upperRightY:3650.0 lowerRightX:2569.0 lowerRightY:3750.0];//受付
            [self mapInformation: point number:7 upperLeftX:2608.0 upperLeftY:4030.0 lowerLeftX:2608.0 lowerLeftY:4122.0 upperRightX:2721.0 upperRightY:4030.0 lowerRightX:2720.0 lowerRightY:4122.0];//用品保管庫
            [self mapInformation: point number:8 upperLeftX:2608.0 upperLeftY:3905.0 lowerLeftX:2608.0 lowerLeftY:4029.0 upperRightX:2721.0 upperRightY:3903.0 lowerRightX:2721.0 lowerRightY:4028.0];//教務室
            [self mapInformation: point number:9 upperLeftX:2607.0 upperLeftY:3783.0 lowerLeftX:2607.0 lowerLeftY:3904.0 upperRightX:2720.0 upperRightY:3782.0 lowerRightX:2721.0 lowerRightY:3902.0];//小会議室
            [self mapInformation: point number:10 upperLeftX:2608.0 upperLeftY:3683.0 lowerLeftX:2607.0 lowerLeftY:3782.0 upperRightX:2720.0 upperRightY:3682.0 lowerRightX:2720.0 lowerRightY:3782.0];//トイレ（1F・教員用）
            [self mapInformation: point number:11 upperLeftX:2462.0 upperLeftY:3363.0 lowerLeftX:2461.0 lowerLeftY:3422.0 upperRightX:2503.0 upperRightY:3364.0 lowerRightX:2053.0 lowerRightY:3423.0];//応接室1
            [self mapInformation: point number:12 upperLeftX:2504.0 upperLeftY:3387.0 lowerLeftX:2503.0 lowerLeftY:3422.0 upperRightX:2567.0 upperRightY:3387.0 lowerRightX:2568.0 lowerRightY:3422.0];//応接室2
            [self mapInformation: point number:13 upperLeftX:2462.0 upperLeftY:3289.0 lowerLeftX:2461.0 lowerLeftY:3363.0 upperRightX:2567.0 upperRightY:3291.0 lowerRightX:2568.0 lowerRightY:3363.0];//学院長室
            [self mapInformation: point number:14 upperLeftX:2610.0 upperLeftY:3190.0 lowerLeftX:2610.0 lowerLeftY:3294.0 upperRightX:2719.0 upperRightY:3189.0 lowerRightX:2719.0 lowerRightY:3294.0];//トイレ（1F）
            [self mapInformation: point number:15 upperLeftX:2610.0 upperLeftY:3295.0 lowerLeftX:2610.0 lowerLeftY:3353.0 upperRightX:2664.0 upperRightY:3295.0 lowerRightX:2665.0 lowerRightY:3354.0];//給湯室
            [self mapInformation: point number:16 upperLeftX:2664.0 upperLeftY:3294.0 lowerLeftX:2664.0 lowerLeftY:3353.0 upperRightX:2692.0 upperRightY:3295.0 lowerRightX:2692.0 lowerRightY:3354.0];//放送室1
            [self mapInformation: point number:17 upperLeftX:2692.0 upperLeftY:3294.0 lowerLeftX:2693.0 lowerLeftY:3352.0 upperRightX:2718.0 upperRightY:3294.0 lowerRightX:2719.0 lowerRightY:3354.0];//放送室2
            [self mapInformation: point number:18 upperLeftX:2611.0 upperLeftY:3383.0 lowerLeftX:2611.0 lowerLeftY:3423.0 upperRightX:2687.0 upperRightY:3383.0 lowerRightX:2689.0 lowerRightY:3423.0];//中学部教務室
            [self mapInformation: point number:52 upperLeftX:2840.0 upperLeftY:3218.0 lowerLeftX:2840.0 lowerLeftY:3422.0 upperRightX:2922.0 upperRightY:3282.0 lowerRightX:2922.0 lowerRightY:3422.0];//トイレ
            [self mapInformation: point number:53 upperLeftX:2921.0 upperLeftY:3281.0 lowerLeftX:2922.0 lowerLeftY:3423.0 upperRightX:3080.0 upperRightY:3282.0 lowerRightX:3080.0 lowerRightY:3421.0];//技術教室
            [self mapInformation: point number:54 upperLeftX:3080.0 upperLeftY:3280.0 lowerLeftX:3081.0 lowerLeftY:3423.0 upperRightX:3137.0 upperRightY:3280.0 lowerRightX:3422.0 lowerRightY:3422.0];//技術化研究室
            [self mapInformation: point number:55 upperLeftX:3137.0 upperLeftY:3280.0 lowerLeftX:3137.0 lowerLeftY:3423.0 upperRightX:3441.0 upperRightY:3280.0 lowerRightX:3442.0 lowerRightY:3422.0];//マルチメディア多目的教室
            [self mapInformation: point number:56 upperLeftX:2841.0 upperLeftY:3465.0 lowerLeftX:2844.0 lowerLeftY:3907.0 upperRightX:3441.0 upperRightY:3463.0 lowerRightX:3444.0 lowerRightY:3907.0];//図書室・総合情報センター
            [self mapInformation: point number:66 upperLeftX:3440.0 upperLeftY:2286.0 lowerLeftX:3440.0 lowerLeftY:2414.0 upperRightX:3571.0 upperRightY:2286.0 lowerRightX:3571.0 lowerRightY:2416.0];//多目的室（西）
            [self mapInformation: point number:67 upperLeftX:3572.0 upperLeftY:2286.0 lowerLeftX:3572.0 lowerLeftY:2415.0 upperRightX:3703.0 upperRightY:2286.0 lowerRightX:3704.0 lowerRightY:2414.0];//多目的室（東）
            [self mapInformation: point number:68 upperLeftX:3704.0 upperLeftY:2286.0 lowerLeftX:3703.0 lowerLeftY:2413.0 upperRightX:3837.0 upperRightY:2286.0 lowerRightX:3838.0 lowerRightY:2413.0];//3-A
            [self mapInformation: point number:69 upperLeftX:3838.0 upperLeftY:2286.0 lowerLeftX:3837.0 lowerLeftY:2413.0 upperRightX:3970.0 upperRightY:2286.0 lowerRightX:3970.0 lowerRightY:2413.0];//3-B
            [self mapInformation: point number:70 upperLeftX:3970.0 upperLeftY:2286.0 lowerLeftX:3971.0 lowerLeftY:2414.0 upperRightX:4103.0 upperRightY:2287.0 lowerRightX:4105.0 lowerRightY:2412.0];//3-C
            [self mapInformation: point number:71 upperLeftX:3705.0 upperLeftY:2582.0 lowerLeftX:3705.0 lowerLeftY:2705.0 upperRightX:3839.0 upperRightY:2582.0 lowerRightX:3839.0 lowerRightY:2703.0];//3-E
            [self mapInformation: point number:72 upperLeftX:3839.0 upperLeftY:2582.0 lowerLeftX:3839.0 lowerLeftY:2705.0 upperRightX:3972.0 upperRightY:2581.0 lowerRightX:3972.0 lowerRightY:2706.0];//3-D
            [self mapInformation: point number:73 upperLeftX:3971.0 upperLeftY:2582.0 lowerLeftX:3972.0 lowerLeftY:2705.0 upperRightX:4105.0 upperRightY:2582.0 lowerRightX:4106.0 lowerRightY:2706.0];//ラウンジ
            [self mapInformation: point number:74 upperLeftX:3810.0 upperLeftY:2452.0 lowerLeftX:3809.0 lowerLeftY:2538.0 upperRightX:3946.0 upperRightY:2453.0 lowerRightX:3947.0 lowerRightY:2538.0];//トイレ
            [self mapInformation: point number:85 upperLeftX:3958.0 upperLeftY:3578.0 lowerLeftX:4020.0 lowerLeftY:3826.0 upperRightX:4085.0 upperRightY:3543.0 lowerRightX:4152.0 lowerRightY:3789.0];//電気室
            [self mapInformation: point number:86 upperLeftX:3923.0 upperLeftY:3454.0 lowerLeftX:3955.0 lowerLeftY:3576.0 upperRightX:4052.0 upperRightY:3422.0 lowerRightX:4084.0 lowerRightY:3541.0];//書道教室
            [self mapInformation: point number:87 upperLeftX:3914.0 upperLeftY:3430.0 lowerLeftX:3922.0 lowerLeftY:3456.0 upperRightX:4044.0 upperRightY:3395.0 lowerRightX:4051.0 lowerRightY:3421.0];//１Fトイレ（生徒用）
            [self mapInformation: point number:88 upperLeftX:3887.0 upperLeftY:3332.0 lowerLeftX:3915.0 lowerLeftY:3430.0 upperRightX:4017.0 upperRightY:3297.0 lowerRightX:4045.0 lowerRightY:3396.0];//1Fトイレ（教員用）
            [self mapInformation: point number:89 upperLeftX:3856.0 upperLeftY:3216.0 lowerLeftX:3888.0 lowerLeftY:3332.0 upperRightX:3985.0 upperRightY:3181.0 lowerRightX:4017.0 lowerRightY:3297.0];//英語科研究室
            [self mapInformation: point number:90 upperLeftX:3822.0 upperLeftY:3091.0 lowerLeftX:3865.0 lowerLeftY:3126.0 upperRightX:3950.0 upperRightY:3056.0 lowerRightX:3985.0 lowerRightY:3181.0];//仏露語科研究室、独中語科研究室
            [self mapInformation: point number:91 upperLeftX:3786.0 upperLeftY:2963.0 lowerLeftX:3821.0 lowerLeftY:3091.0 upperRightX:3916.0 upperRightY:2928.0 lowerRightX:3951.0 lowerRightY:3055.0];//数学科研究室
            [self mapInformation: point number:92 upperLeftX:3612.0 upperLeftY:3733.0 lowerLeftX:3612.0 lowerLeftY:3855.0 upperRightX:3791.0 upperRightY:3733.0 lowerRightX:3791.0 lowerRightY:3855.0];//購買
            [self mapInformation: point number:93 upperLeftX:3612.0 upperLeftY:3679.0 lowerLeftX:3613.0 lowerLeftY:3732.0 upperRightX:3748.0 upperRightY:3680.0 lowerRightX:3748.0 lowerRightY:3733.0];//警備室
            [self mapInformation: point number:94 upperLeftX:3612.0 upperLeftY:3594.0 lowerLeftX:3612.0 lowerLeftY:3679.0 upperRightX:3747.0 upperRightY:3594.0 lowerRightX:3747.0 lowerRightY:3679.0];//備品保管庫
            [self mapInformation: point number:95 upperLeftX:3612.0 upperLeftY:3466.0 lowerLeftX:3612.0 lowerLeftY:3595.0 upperRightX:3748.0 upperRightY:3467.0 lowerRightX:3748.0 lowerRightY:3595.0];//国語研究室
            [self mapInformation: point number:96 upperLeftX:3611.0 upperLeftY:3282.0 lowerLeftX:3610.0 lowerLeftY:3347.0 upperRightX:3746.0 upperRightY:3283.0 lowerRightX:3747.0 lowerRightY:3347.0];//公民科研究室
            [self mapInformation: point number:97 upperLeftX:3612.0 upperLeftY:3213.0 lowerLeftX:3612.0 lowerLeftY:3282.0 upperRightX:3746.0 upperRightY:3213.0 lowerRightX:3747.0 lowerRightY:3282.0];//地歴科研究室
            [self mapInformation: point number:98 upperLeftX:3610.0 upperLeftY:3097.0 lowerLeftX:3612.0 lowerLeftY:3213.0 upperRightX:3746.0 upperRightY:3098.0 lowerRightX:3746.0 lowerRightY:3213.0];//社会科研究室
            [self mapInformation: point number:99 upperLeftX:3609.0 upperLeftY:2963.0 lowerLeftX:3610.0 lowerLeftY:3097.0 upperRightX:3745.0 upperRightY:2963.0 lowerRightX:3746.0 lowerRightY:3097.0];//ゼミ室1
            [self mapInformation: point number:135 upperLeftX:571.0 upperLeftY:2024.0 lowerLeftX:572.0 lowerLeftY:2143.0 upperRightX:764.0 upperRightY:2024.0 lowerRightX:764.0 lowerRightY:2141.0];//家庭科調理室
            [self mapInformation: point number:136 upperLeftX:764.0 upperLeftY:2025.0 lowerLeftX:765.0 lowerLeftY:2142.0 upperRightX:809.0 upperRightY:2024.0 lowerRightX:809.0 lowerRightY:2142.0];//家庭科準備室
            [self mapInformation: point number:137 upperLeftX:572.0 upperLeftY:2144.0 lowerLeftX:574.0 lowerLeftY:2597.0 upperRightX:810.0 upperRightY:2143.0 lowerRightX:811.0 lowerRightY:2596.0];//食堂
            [self mapInformation: point number:138 upperLeftX:974.0 upperLeftY:2557.0 lowerLeftX:974.0 lowerLeftY:2598.0 upperRightX:1040.0 upperRightY:2557.0 lowerRightX:1040.0 lowerRightY:2599.0];//労務員室
            [self mapInformation: point number:139 upperLeftX:975.0 upperLeftY:2669.0 lowerLeftX:975.0 lowerLeftY:2830.0 upperRightX:1091.0 upperRightY:2697.0 lowerRightX:1091.0 lowerRightY:2831.0];//美術準備室
            [self mapInformation: point number:140 upperLeftX:1092.0 upperLeftY:2642.0 lowerLeftX:1092.0 lowerLeftY:2830.0 upperRightX:1208.0 upperRightY:2641.0 lowerRightX:1208.0 lowerRightY:2831.0];//第二美術室
            [self mapInformation: point number:141 upperLeftX:1208.0 upperLeftY:2641.0 lowerLeftX:1208.0 lowerLeftY:2831.0 upperRightX:1328.0 upperRightY:2641.0 lowerRightX:1329.0 lowerRightY:2831.0];//第一美術室
            [self mapInformation: point number:142 upperLeftX:1558.0 upperLeftY:2672.0 lowerLeftX:1558.0 lowerLeftY:2885.0 upperRightX:1677.0 upperRightY:2672.0 lowerRightX:1678.0 lowerRightY:2884.0];//生物実験室
            [self mapInformation: point number:143 upperLeftX:1677.0 upperLeftY:2672.0 lowerLeftX:1678.0 lowerLeftY:2884.0 upperRightX:1737.0 upperRightY:2672.0 lowerRightX:1737.0 lowerRightY:2885.0];//生物教員室
            [self mapInformation: point number:144 upperLeftX:1737.0 upperLeftY:2672.0 lowerLeftX:1738.0 lowerLeftY:2885.0 upperRightX:1797.0 upperRightY:2637.0 lowerRightX:1798.0 lowerRightY:2885.0];//物理教員室
            [self mapInformation: point number:145 upperLeftX:1797.0 upperLeftY:2672.0 lowerLeftX:1798.0 lowerLeftY:2884.0 upperRightX:1911.0 upperRightY:2673.0 lowerRightX:1912.0 lowerRightY:2884.0];//物理第二実験室
            [self mapInformation: point number:146 upperLeftX:1911.0 upperLeftY:2672.0 lowerLeftX:1912.0 lowerLeftY:2884.0 upperRightX:2024.0 upperRightY:2671.0 lowerRightX:2025.0 lowerRightY:2883.0];//物理第一実験室
            [self mapInformation: point number:147 upperLeftX:2024.0 upperLeftY:2671.0 lowerLeftX:2025.0 lowerLeftY:2884.0 upperRightX:2138.0 upperRightY:2672.0 lowerRightX:2139.0 lowerRightY:2882.0];//地学実験室
            [self mapInformation: point number:148 upperLeftX:1281.0 upperLeftY:2556.0 lowerLeftX:1282.0 lowerLeftY:2599.0 upperRightX:1327.0 upperRightY:2557.0 lowerRightX:1327.0 lowerRightY:2599.0];//幹事会室
            [self mapInformation: point number:149 upperLeftX:1618.0 upperLeftY:2556.0 lowerLeftX:1617.0 lowerLeftY:2640.0 upperRightX:1671.0 upperRightY:2555.0 lowerRightX:1671.0 lowerRightY:2640.0];//トイレ
            [self mapInformation: point number:150 upperLeftX:1671.0 upperLeftY:2555.0 lowerLeftX:1671.0 lowerLeftY:2641.0 upperRightX:1715.0 upperRightY:2555.0 lowerRightX:1716.0 lowerRightY:2640.0];//飼育・培養室
            [self mapInformation: point number:151 upperLeftX:1715.0 upperLeftY:2555.0 lowerLeftX:1716.0 lowerLeftY:2640.0 upperRightX:1752.0 upperRightY:2555.0 lowerRightX:1752.0 lowerRightY:2640.0];//生物第一準備室
            [self mapInformation: point number:152 upperLeftX:1751.0 upperLeftY:2555.0 lowerLeftX:1752.0 lowerLeftY:2640.0 upperRightX:1790.0 upperRightY:2555.0 lowerRightX:1790.0 lowerRightY:2640.0];//生物第二準備室
            [self mapInformation: point number:153 upperLeftX:2076.0 upperLeftY:2554.0 lowerLeftX:2076.0 lowerLeftY:2612.0 upperRightX:2137.0 upperRightY:2554.0 lowerRightX:2137.0 lowerRightY:2612.0];//地学教員室
            [self mapInformation: point  number:160 upperLeftX:1725.0 upperLeftY:2050.0 lowerLeftX:1725.0 lowerLeftY:2436.0 upperRightX:2123.0 upperRightY:2050.0 lowerRightX:2123.0 lowerRightY:2435.0];//第二体育館
            [self mapInformation: point  number:161 upperLeftX:2123.0 upperLeftY:2195.0 lowerLeftX:2123.0 lowerLeftY:2373.0 upperRightX:2172.0 upperRightY:2195.0 lowerRightX:2172.0 lowerRightY:2373.0];//第二体育館玄関
            break;
        case 2:
            [self mapInformation: point number:19 upperLeftX:2464.0 upperLeftY:4148.0 lowerLeftX:2464.0 lowerLeftY:4278.0 upperRightX:2569.0 upperRightY:4147.0 lowerRightX:2569.0 lowerRightY:4279.0];//1-4
            [self mapInformation: point number:20 upperLeftX:2464.0 upperLeftY:4026.0 lowerLeftX:2464.0 lowerLeftY:4146.0 upperRightX:2569.0 upperRightY:4026.0 lowerRightX:2569.0 lowerRightY:4147.0];//1-3
            [self mapInformation: point number:21 upperLeftX:2464.0 upperLeftY:3905.0 lowerLeftX:2463.0 lowerLeftY:4025.0 upperRightX:2568.0 upperRightY:3906.0 lowerRightX:2569.0 lowerRightY:4026.0];//1-2
            [self mapInformation: point number:22 upperLeftX:2464.0 upperLeftY:3784.0 lowerLeftX:2464.0 lowerLeftY:3904.0 upperRightX:2570.0 upperRightY:3906.0 lowerRightX:2570.0 lowerRightY:4026.0];//1-1
            [self mapInformation: point number:23 upperLeftX:2607.0 upperLeftY:4045.0 lowerLeftX:2068.0 lowerLeftY:4123.0 upperRightX:2721.0 upperRightY:4045.0 lowerRightX:2721.0 lowerRightY:4124.0];//多目的教室C
            [self mapInformation: point number:24 upperLeftX:2607.0 upperLeftY:3976.0 lowerLeftX:2608.0 lowerLeftY:4044.0 upperRightX:2720.0 upperRightY:3976.0 lowerRightX:2721.0 lowerRightY:4045.0];//多目的教室B
            [self mapInformation: point number:25 upperLeftX:2608.0 upperLeftY:3906.0 lowerLeftX:2607.0 lowerLeftY:3975.0 upperRightX:2720.0 upperRightY:3905.0 lowerRightX:2720.0 lowerRightY:3975.0];//多目的教室A
            [self mapInformation: point number:26 upperLeftX:2607.0 upperLeftY:3856.0 lowerLeftX:2607.0 lowerLeftY:3904.0 upperRightX:2720.0 upperRightY:3855.0 lowerRightX:2720.0 lowerRightY:3094.0];//中学部幹事会室
            [self mapInformation: point number:27 upperLeftX:2608.0 upperLeftY:3784.0 lowerLeftX:2607.0 lowerLeftY:3857.0 upperRightX:2719.0 upperRightY:3784.0 lowerRightX:2720.0 lowerRightY:3856.0];//倉庫
            [self mapInformation: point number:28 upperLeftX:2608.0 upperLeftY:3684.0 lowerLeftX:2608.0 lowerLeftY:3783.0 upperRightX:2719.0 upperRightY:3684.0 lowerRightX:2720.0 lowerRightY:3783.0];//トイレ
            [self mapInformation: point number:29 upperLeftX:2463.0 upperLeftY:3665.0 lowerLeftX:2463.0 lowerLeftY:3784.0 upperRightX:2568.0 upperRightY:3666.0 lowerRightX:2569.0 lowerRightY:3785.0];//保健室
            [self mapInformation: point number:30 upperLeftX:2462.0 upperLeftY:3622.0 lowerLeftX:2463.0 lowerLeftY:3664.0 upperRightX:2569.0 upperRightY:3623.0 lowerRightX:2569.0 lowerRightY:3664.0];//印刷室
            [self mapInformation: point number:31 upperLeftX:2463.0 upperLeftY:3292.0 lowerLeftX:2462.0 lowerLeftY:3621.0 upperRightX:2567.0 upperRightY:3293.0 lowerRightX:2568.0 lowerRightY:3621.0];//中学部教員室
            [self mapInformation: point number:32 upperLeftX:2612.0 upperLeftY:3386.0 lowerLeftX:2611.0 lowerLeftY:3424.0 upperRightX:2648.0 upperRightY:3386.0 lowerRightX:2648.0 lowerRightY:3425.0];//面談室1
            [self mapInformation: point number:33 upperLeftX:2648.0 upperLeftY:3387.0 lowerLeftX:2649.0 lowerLeftY:3426.0 upperRightX:2688.0 upperRightY:3386.0 lowerRightX:2689.0 lowerRightY:3424.0];//面談室2
            [self mapInformation: point number:34 upperLeftX:2689.0 upperLeftY:2256.0 lowerLeftX:2689.0 lowerLeftY:3425.0 upperRightX:2720.0 upperRightY:3355.0 lowerRightX:2720.0 lowerRightY:3425.0];//面談室3
            [self mapInformation: point number:35 upperLeftX:2611.0 upperLeftY:3192.0 lowerLeftX:2611.0 lowerLeftY:3295.0 upperRightX:2719.0 upperRightY:3192.0 lowerRightX:2719.0 lowerRightY:3295.0];//トイレ（教員用）
            [self mapInformation: point number:57 upperLeftX:2841.0 upperLeftY:3283.0 lowerLeftX:2841.0 lowerLeftY:3424.0 upperRightX:3039.0 upperRightY:3283.0 lowerRightX:3040.0 lowerRightY:3423.0];//第一コンピューター室
            [self mapInformation: point number:58 upperLeftX:3040.0 upperLeftY:3283.0 lowerLeftX:3040.0 lowerLeftY:3424.0 upperRightX:3237.0 upperRightY:3283.0 lowerRightX:3237.0 lowerRightY:3423.0];//第二コンピューター室
            [self mapInformation: point number:59 upperLeftX:3236.0 upperLeftY:3283.0 lowerLeftX:3237.0 lowerLeftY:3424.0 upperRightX:3441.0 upperRightY:3284.0 lowerRightX:3424.0 lowerRightY:3424.0];//第三コンピューター室
            [self mapInformation: point number:60 upperLeftX:2844.0 upperLeftY:3496.0 lowerLeftX:2843.0 lowerLeftY:3593.0 upperRightX:2991.0 upperRightY:3496.0 lowerRightX:2993.0 lowerRightY:3593.0];//情報研究科・音楽家準備室
            [self mapInformation: point number:61 upperLeftX:2843.0 upperLeftY:3594.0 lowerLeftX:2844.0 lowerLeftY:3722.0 upperRightX:2992.0 upperRightY:3593.0 lowerRightX:2995.0 lowerRightY:3720.0];//マルチメディア教材作成室
            [self mapInformation: point number:62 upperLeftX:3230.0 upperLeftY:3465.0 lowerLeftX:3231.0 lowerLeftY:3707.0 upperRightX:3381.0 upperRightY:3466.0 lowerRightX:3382.0 lowerRightY:3708.0];//小講堂
            [self mapInformation: point number:63 upperLeftX:2844.0 upperLeftY:3763.0 lowerLeftX:2844.0 lowerLeftY:3910.0 upperRightX:3042.0 upperRightY:3762.0 lowerRightX:3042.0 lowerRightY:3909.0];//第一CALL室
            [self mapInformation: point number:64 upperLeftX:3042.0 upperLeftY:3762.0 lowerLeftX:3042.0 lowerLeftY:3910.0 upperRightX:3241.0 upperRightY:3762.0 lowerRightX:3242.0 lowerRightY:3909.0];//第二CALL室
            [self mapInformation: point number:65 upperLeftX:3241.0 upperLeftY:3763.0 lowerLeftX:3242.0 lowerLeftY:3909.0 upperRightX:3442.0 upperRightY:3762.0 lowerRightX:3442.0 lowerRightY:3910.0];//第三CALL室
            [self mapInformation: point number:75 upperLeftX:3441.0 upperLeftY:2288.0 lowerLeftX:3442.0 lowerLeftY:2416.0 upperRightX:3573.0 upperRightY:2288.0 lowerRightX:3574.0 lowerRightY:2415.0];//3-F
            [self mapInformation: point number:76 upperLeftX:3573.0 upperLeftY:2288.0 lowerLeftX:3573.0 lowerLeftY:2415.0 upperRightX:3706.0 upperRightY:2287.0 lowerRightX:3706.0 lowerRightY:2415.0];//3-G
            [self mapInformation: point number:77 upperLeftX:3706.0 upperLeftY:2288.0 lowerLeftX:3706.0 lowerLeftY:2415.0 upperRightX:3840.0 upperRightY:2289.0 lowerRightX:3840.0 lowerRightY:2414.0];//3-H
            [self mapInformation: point number:78 upperLeftX:3708.0 upperLeftY:2582.0 lowerLeftX:3707.0 lowerLeftY:2705.0 upperRightX:3841.0 upperRightY:2585.0 lowerRightX:3841.0 lowerRightY:2706.0];//3-L
            [self mapInformation: point number:79 upperLeftX:3839.0 upperLeftY:2289.0 lowerLeftX:3840.0 lowerLeftY:2415.0 upperRightX:3971.0 upperRightY:2289.0 lowerRightX:3972.0 lowerRightY:2415.0];//3-I
            [self mapInformation: point number:80 upperLeftX:3971.0 upperLeftY:2289.0 lowerLeftX:3972.0 lowerLeftY:2415.0 upperRightX:4105.0 upperRightY:2289.0 lowerRightX:4106.0 lowerRightY:2415.0];//3-J
            [self mapInformation: point number:81 upperLeftX:3841.0 upperLeftY:2583.0 lowerLeftX:3841.0 lowerLeftY:2706.0 upperRightX:3972.0 upperRightY:2582.0 lowerRightX:3974.0 lowerRightY:2706.0];//3-K
            [self mapInformation: point number:82 upperLeftX:3973.0 upperLeftY:2583.0 lowerLeftX:3973.0 lowerLeftY:2707.0 upperRightX:4106.0 upperRightY:2583.0 lowerRightX:4106.0 lowerRightY:2706.0];//ゼミ室2
            [self mapInformation: point number:83 upperLeftX:3811.0 upperLeftY:2453.0 lowerLeftX:3811.0 lowerLeftY:2540.0 upperRightX:3904.0 upperRightY:2454.0 lowerRightX:3904.0 lowerRightY:2540.0];//トイレ
            [self mapInformation: point number:84 upperLeftX:3904.0 upperLeftY:2453.0 lowerLeftX:3905.0 lowerLeftY:2499.0 upperRightX:3947.0 upperRightY:2453.0 lowerRightX:3948.0 lowerRightY:2498.0];//教員用トイレ
            [self mapInformation: point number:100 upperLeftX:3611.0 upperLeftY:3471.0 lowerLeftX:3613.0 lowerLeftY:3599.0 upperRightX:3748.0 upperRightY:3472.0 lowerRightX:3748.0 lowerRightY:3600.0];//1-L
            [self mapInformation: point number:101 upperLeftX:3612.0 upperLeftY:3599.0 lowerLeftX:3613.0 lowerLeftY:3736.0 upperRightX:3748.0 upperRightY:3600.0 lowerRightX:3748.0 lowerRightY:3736.0];//1-K
            [self mapInformation: point number:102 upperLeftX:3614.0 upperLeftY:3736.0 lowerLeftX:3613.0 lowerLeftY:3859.0 upperRightX:3749.0 upperRightY:3736.0 lowerRightX:3749.0 lowerRightY:3858.0];//1-J
            [self mapInformation: point number:103 upperLeftX:3921.0 upperLeftY:3461.0 lowerLeftX:3954.0 lowerLeftY:3582.0 upperRightX:4051.0 upperRightY:3425.0 lowerRightX:4085.0 lowerRightY:3548.0];//1-G
            [self mapInformation: point number:104 upperLeftX:3954.0 upperLeftY:3583.0 lowerLeftX:3986.0 lowerLeftY:3703.0 upperRightX:4084.0 upperRightY:3547.0 lowerRightX:4118.0 lowerRightY:3667.0];//1-H
            [self mapInformation: point number:105 upperLeftX:3987.0 upperLeftY:3703.0 lowerLeftX:4021.0 lowerLeftY:3831.0 upperRightX:4117.0 upperRightY:3668.0 lowerRightX:4152.0 lowerRightY:3795.0];//1-I
            [self mapInformation: point number:106 upperLeftX:3791.0 upperLeftY:3754.0 lowerLeftX:3792.0 lowerLeftY:3907.0 upperRightX:3951.0 upperRightY:3743.0 lowerRightX:3982.0 lowerRightY:3854.0];//ラウンジ
            [self mapInformation: point number:107 upperLeftX:3888.0 upperLeftY:3336.0 lowerLeftX:3915.0 lowerLeftY:3435.0 upperRightX:4017.0 upperRightY:3301.0 lowerRightX:4044.0 lowerRightY:3400.0];//トイレ
            [self mapInformation: point number:108 upperLeftX:3612.0 upperLeftY:3216.0 lowerLeftX:3612.0 lowerLeftY:3350.0 upperRightX:3748.0 upperRightY:3216.0 lowerRightX:3748.0 lowerRightY:3351.0];//1-A
            [self mapInformation: point number:109 upperLeftX:3611.0 upperLeftY:3094.0 lowerLeftX:3611.0 lowerLeftY:3216.0 upperRightX:3747.0 upperRightY:3095.0 lowerRightX:3747.0 lowerRightY:3217.0];//1-B
            [self mapInformation: point number:110 upperLeftX:3611.0 upperLeftY:2965.0 lowerLeftX:3611.0 lowerLeftY:3094.0 upperRightX:3747.0 upperRightY:2966.0 lowerRightX:3748.0 lowerRightY:3094.0];//1-C
            [self mapInformation: point number:111 upperLeftX:3788.0 upperLeftY:2966.0 lowerLeftX:3822.0 lowerLeftY:3093.0 upperRightX:3918.0 upperRightY:2930.0 lowerRightX:3952.0 lowerRightY:3057.0];//1-D
            [self mapInformation: point number:112 upperLeftX:3823.0 upperLeftY:3094.0 lowerLeftX:3857.0 lowerLeftY:3220.0 upperRightX:3952.0 upperRightY:3057.0 lowerRightX:3985.0 lowerRightY:3183.0];//1-E
            [self mapInformation: point number:113 upperLeftX:3857.0 upperLeftY:3219.0 lowerLeftX:3888.0 lowerLeftY:3336.0 upperRightX:3986.0 upperRightY:3184.0 lowerRightX:4018.0 lowerRightY:3302.0];//1-F
            [self mapInformation: point number:126 upperLeftX:2455.0 upperLeftY:2056.0 lowerLeftX:2455.0 lowerLeftY:2185.0 upperRightX:2562.0 upperRightY:2056.0 lowerRightX:2562.0 lowerRightY:2186.0];//トイレ１
            [self mapInformation: point number:127 upperLeftX:2456.0 upperLeftY:2320.0 lowerLeftX:2456.0 lowerLeftY:2447.0 upperRightX:2562.0 upperRightY:2319.0 lowerRightX:2563.0 lowerRightY:2447.0];//トイレ２
            [self mapInformation: point number:128 upperLeftX:2562.0 upperLeftY:2056.0 lowerLeftX:2563.0 lowerLeftY:2447.0 upperRightX:3146.0 upperRightY:2053.0 lowerRightX:3148.0 lowerRightY:2455.0];//講堂
            [self mapInformation: point number:129 upperLeftX:3147.0 upperLeftY:2014.0 lowerLeftX:3147.0 lowerLeftY:2211.0 upperRightX:3267.0 upperRightY:2014.0 lowerRightX:3267.0 lowerRightY:3267.0];//音楽室
            [self mapInformation: point number:130 upperLeftX:3149.0 upperLeftY:2213.0 lowerLeftX:3149.0 lowerLeftY:2278.0 upperRightX:3219.0 upperRightY:2213.0 lowerRightX:3219.0 lowerRightY:2277.0];//楽器倉庫1
            [self mapInformation: point number:131 upperLeftX:3149.0 upperLeftY:2277.0 lowerLeftX:3149.0 lowerLeftY:2339.0 upperRightX:3219.0 upperRightY:2277.0 lowerRightX:3220.0 lowerRightY:2337.0];//楽器倉庫2
            [self mapInformation: point number:132 upperLeftX:3219.0 upperLeftY:2213.0 lowerLeftX:3219.0 lowerLeftY:2336.0 upperRightX:3267.0 upperRightY:2213.0 lowerRightX:3268.0 lowerRightY:2337.0];//音楽準備室
            [self mapInformation: point number:133 upperLeftX:3149.0 upperLeftY:2338.0 lowerLeftX:3149.0 lowerLeftY:2487.0 upperRightX:3267.0 upperRightY:2338.0 lowerRightX:3269.0 lowerRightY:2487.0];//音楽室2
            [self mapInformation: point number:134 upperLeftX:2456.0 upperLeftY:2056.0 lowerLeftX:2456.0 lowerLeftY:2447.0 upperRightX:3150.0 upperRightY:2055.0 lowerRightX:3150.0 lowerRightY:2446.0];//講堂
            break;
        case 3:
            [self mapInformation: point number:36 upperLeftX:2461.0 upperLeftY:3782.0 lowerLeftX:2461.0 lowerLeftY:3901.0 upperRightX:2566.0 upperRightY:3782.0 lowerRightX:2566.0 lowerRightY:3902.0];//3-1
            [self mapInformation: point number:37 upperLeftX:2461.0 upperLeftY:3902.0 lowerLeftX:2460.0 lowerLeftY:4023.0 upperRightX:2566.0 upperRightY:3902.0 lowerRightX:2567.0 lowerRightY:4023.0];//3-2
            [self mapInformation: point number:38 upperLeftX:2462.0 upperLeftY:4022.0 lowerLeftX:2461.0 lowerLeftY:4144.0 upperRightX:2566.0 upperRightY:4024.0 lowerRightX:2567.0 lowerRightY:4146.0];//3-3
            [self mapInformation: point number:39 upperLeftX:2462.0 upperLeftY:4145.0 lowerLeftX:2461.0 lowerLeftY:4274.0 upperRightX:2566.0 upperRightY:4145.0 lowerRightX:2567.0 lowerRightY:4275.0];//3-4
            [self mapInformation: point number:40 upperLeftX:2605.0 upperLeftY:3783.0 lowerLeftX:3783.0 lowerLeftY:2605.0 upperRightX:2718.0 upperRightY:3783.0 lowerRightX:2718.0 lowerRightY:3921.0];//物理・地学実験室
            [self mapInformation: point number:41 upperLeftX:2605.0 upperLeftY:3922.0 lowerLeftX:2605.0 lowerLeftY:3973.0 upperRightX:2718.0 upperRightY:3922.0 lowerRightX:2718.0 lowerRightY:3973.0];//理科実験準備室
            [self mapInformation: point number:42 upperLeftX:2604.0 upperLeftY:3974.0 lowerLeftX:2604.0 lowerLeftY:4121.0 upperRightX:2718.0 upperRightY:3974.0 lowerRightX:2718.0 lowerRightY:4121.0];//化学・生物実験室
            [self mapInformation: point number:43 upperLeftX:2605.0 upperLeftY:3682.0 lowerLeftX:2605.0 lowerLeftY:3782.0 upperRightX:2717.0 upperRightY:3682.0 lowerRightX:2718.0 lowerRightY:3781.0];//トイレ
            [self mapInformation: point number:44 upperLeftX:2461.0 upperLeftY:3719.0 lowerLeftX:2461.0 lowerLeftY:3781.0 upperRightX:2566.0 upperRightY:3719.0 lowerRightX:2566.0 lowerRightY:3782.0];//ミーティングルーム2
            [self mapInformation: point number:45 upperLeftX:2461.0 upperLeftY:3661.0 lowerLeftX:2462.0 lowerLeftY:3719.0 upperRightX:2566.0 upperRightY:3664.0 lowerRightX:2566.0 lowerRightY:3718.0];//被服準備室
            [self mapInformation: point number:46 upperLeftX:2461.0 upperLeftY:3534.0 lowerLeftX:2461.0 lowerLeftY:3662.0 upperRightX:2566.0 upperRightY:3535.0 lowerRightX:2566.0 lowerRightY:3663.0];//被服室
            [self mapInformation: point number:47 upperLeftX:2461.0 upperLeftY:3289.0 lowerLeftX:2461.0 lowerLeftY:3412.0 upperRightX:2567.0 upperRightY:3288.0 lowerRightX:2566.0 lowerRightY:3413.0];//2-1
            [self mapInformation: point number:48 upperLeftX:2461.0 upperLeftY:3413.0 lowerLeftX:2460.0 lowerLeftY:3533.0 upperRightX:2566.0 upperRightY:3413.0 lowerRightX:2566.0 lowerRightY:3534.0];//2-2
            [self mapInformation: point number:49 upperLeftX:2609.0 upperLeftY:3413.0 lowerLeftX:2609.0 lowerLeftY:3533.0 upperRightX:2718.0 upperRightY:3413.0 lowerRightX:2718.0 lowerRightY:3534.0];//2-3
            [self mapInformation: point number:50 upperLeftX:2609.0 upperLeftY:3292.0 lowerLeftX:2609.0 lowerLeftY:3413.0 upperRightX:2718.0 upperRightY:3292.0 lowerRightX:2718.0 lowerRightY:3412.0];//2-4
            [self mapInformation: point number:51 upperLeftX:2609.0 upperLeftY:3188.0 lowerLeftX:2607.0 lowerLeftY:3258.0 upperRightX:2718.0 upperRightY:3188.0 lowerRightX:2718.0 lowerRightY:3258.0];//トイレ　北
            [self mapInformation: point number:114 upperLeftX:3613.0 upperLeftY:3734.0 lowerLeftX:3613.0 lowerLeftY:3857.0 upperRightX:3749.0 upperRightY:3735.0 lowerRightX:3749.0 lowerRightY:3856.0];//2-J
            [self mapInformation: point number:115 upperLeftX:3614.0 upperLeftY:3596.0 lowerLeftX:3613.0 lowerLeftY:3734.0 upperRightX:3750.0 upperRightY:3597.0 lowerRightX:3750.0 lowerRightY:3735.0];//2-K
            [self mapInformation: point number:116 upperLeftX:3613.0 upperLeftY:3468.0 lowerLeftX:3614.0 lowerLeftY:3569.0 upperRightX:3750.0 upperRightY:3469.0 lowerRightX:3749.0 lowerRightY:3598.0];//2-L
            [self mapInformation: point number:117 upperLeftX:3924.0 upperLeftY:3458.0 lowerLeftX:3956.0 lowerLeftY:3580.0 upperRightX:4054.0 upperRightY:3423.0 lowerRightX:4088.0 lowerRightY:3545.0];//2-G
            [self mapInformation: point number:118 upperLeftX:3957.0 upperLeftY:3583.0 lowerLeftX:3989.0 lowerLeftY:3700.0 upperRightX:4087.0 upperRightY:3545.0 lowerRightX:4120.0 lowerRightY:3667.0];//2-H
            [self mapInformation: point number:119 upperLeftX:3989.0 upperLeftY:3701.0 lowerLeftX:4023.0 lowerLeftY:3828.0 upperRightX:4120.0 upperRightY:3667.0 lowerRightX:4154.0 lowerRightY:3793.0];//2-I
            [self mapInformation: point number:120 upperLeftX:3891.0 upperLeftY:3334.0 lowerLeftX:3918.0 lowerLeftY:3433.0 upperRightX:4021.0 upperRightY:3299.0 lowerRightX:4047.0 lowerRightY:3397.0];//トイレ
            [self mapInformation: point number:121 upperLeftX:3614.0 upperLeftY:3214.0 lowerLeftX:3613.0 lowerLeftY:3347.0 upperRightX:3749.0 upperRightY:3214.0 lowerRightX:3749.0 lowerRightY:3348.0];//2-A
            [self mapInformation: point number:122 upperLeftX:3613.0 upperLeftY:3092.0 lowerLeftX:3613.0 lowerLeftY:3214.0 upperRightX:3749.0 upperRightY:3092.0 lowerRightX:3749.0 lowerRightY:3214.0];//2-B
            [self mapInformation: point number:123 upperLeftX:3791.0 upperLeftY:2964.0 lowerLeftX:3825.0 lowerLeftY:3092.0 upperRightX:3921.0 upperRightY:2929.0 lowerRightX:3956.0 lowerRightY:3055.0];//2-D
            [self mapInformation: point number:124 upperLeftX:3825.0 upperLeftY:3092.0 lowerLeftX:3860.0 lowerLeftY:3218.0 upperRightX:3955.0 upperRightY:3056.0 lowerRightX:3990.0 lowerRightY:3181.0];//2-E
            [self mapInformation: point number:125 upperLeftX:3860.0 upperLeftY:3218.0 lowerLeftX:3891.0 lowerLeftY:3334.0 upperRightX:3990.0 upperRightY:3181.0 lowerRightX:4021.0 lowerRightY:3298.0];//2-F
            [self mapInformation: point number:154 upperLeftX:855.0 upperLeftY:2669.0 lowerLeftX:853.0 lowerLeftY:2817.0 upperRightX:971.0 upperRightY:2669.0 lowerRightX:970.0 lowerRightY:2817.0];//科学実験室（1）
            [self mapInformation: point number:155 upperLeftX:971.0 upperLeftY:2669.0 lowerLeftX:971.0 lowerLeftY:2827.0 upperRightX:1087.0 upperRightY:2667.0 lowerRightX:1086.0 lowerRightY:2828.0];//科学実験室（2）
            [self mapInformation: point number:156 upperLeftX:1087.0 upperLeftY:2668.0 lowerLeftX:1087.0 lowerLeftY:2762.0 upperRightX:1206.0 upperRightY:2668.0 lowerRightX:1207.0 lowerRightY:2760.0];//科学講義室
            [self mapInformation: point number:157 upperLeftX:1086.0 upperLeftY:2761.0 lowerLeftX:1087.0 lowerLeftY:2828.0 upperRightX:1205.0 upperRightY:2760.0 lowerRightX:1206.0 lowerRightY:2826.0];//薬品調整室
            [self mapInformation: point number:158 upperLeftX:1206.0 upperLeftY:2669.0 lowerLeftX:1206.0 lowerLeftY:2827.0 upperRightX:1325.0 upperRightY:2668.0 lowerRightX:1325.0 lowerRightY:2826.0];//科学準備室
            [self mapInformation: point number:159 upperLeftX:1667.0 upperLeftY:2551.0 lowerLeftX:1667.0 lowerLeftY:2628.0 upperRightX:1787.0 upperRightY:2551.0 lowerRightX:1788.0 lowerRightY:2626.0];//トイレ
    }
}

@end
