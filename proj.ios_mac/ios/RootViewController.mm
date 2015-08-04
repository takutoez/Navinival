/****************************************************************************
 Copyright (c) 2013      cocos2d-x.org
 Copyright (c) 2013-2014 Chukong Technologies Inc.

 http://www.cocos2d-x.org

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 ****************************************************************************/

#import "AppDelegate.h"
#import "RootViewController.h"
#import "cocos2d.h"
#import "platform/ios/CCEAGLView-ios.h"
#import "HelloWorldScene.h"
#import "NavigationBarWithSegmentedControl.h"

@implementation RootViewController

// cocos2d application instance
static AppDelegate s_sharedApplication;

/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}*/

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    cocos2d::Application *app = cocos2d::Application::getInstance();
    app->initGLContextAttrs();
    cocos2d::GLViewImpl::convertAttrs();
    
    // Override point for customization after application launch.
    
    // Add the view controller's view to the window and display.
    window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    // Init the CCEAGLView
    CCEAGLView *eaglView = [CCEAGLView viewWithFrame: [window bounds]
                                         pixelFormat: (NSString*)cocos2d::GLViewImpl::_pixelFormat
                                         depthFormat: cocos2d::GLViewImpl::_depthFormat
                                  preserveBackbuffer: NO
                                          sharegroup: nil
                                       multiSampling: NO
                                     numberOfSamples: 0 ];
    self.view = eaglView;
    
    [self.navigationController setValue:[[[NavigationBarWithSegmentedControl alloc]init] autorelease] forKeyPath:@"navigationBar"];
    
    // IMPORTANT: Setting the GLView should be done after creating the RootViewController
    cocos2d::GLView *glview = cocos2d::GLViewImpl::createWithEAGLView(eaglView);
    cocos2d::Director::getInstance()->setOpenGLView(glview);
    
    app->run();
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = 2;
    [locationManager startUpdatingLocation];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    [[delegateFreeSession dataTaskWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/map/beacon/", BASE_URL]]
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (error != nil){
                                NSLog(@"Got response %@ with error %@.\n", response, error);
                            }else{
                                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                _beaconArray = [[NSMutableArray alloc] init];
                                for (NSDictionary *jsonDictionary in jsonArray)
                                {
                                    [_beaconArray addObject:jsonDictionary];
                                }
                            }
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            
                            if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
                                // 生成したUUIDからNSUUIDを作成
                                _proximityUUID = [[NSUUID alloc] initWithUUIDString:@"00000000-9c1d-1001-b000-001c4d389a24"];
                                // CLBeaconRegionを作成
                                _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:_proximityUUID
                                                                                   identifier:@"com.navinival.gakuin"];
                                _beaconRegion.notifyOnEntry = YES;
                                _beaconRegion.notifyOnExit = YES;
                                _beaconRegion.notifyEntryStateOnDisplay = YES;
                                // Beaconによる領域観測を開始
                                [locationManager startMonitoringForRegion:_beaconRegion];
                            }
                        }] resume];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1.0 green:0.196 blue:0.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]] autorelease];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"1階", @"2階", @"3階", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(20, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height - 34, self.view.frame.size.width - 40, 30);
    segmentedControl.tintColor = [UIColor whiteColor];
    [segmentedControl addTarget:self action:@selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    
     MapInformationContainerVisualEffectViewController *mapInformationContaienrViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mapInformationContainer"];
    _mapInformationView = mapInformationContaienrViewController.view;
    _mapInformationView.layer.cornerRadius = 20.0f;
    _mapInformationView.clipsToBounds = true;
    _mapInformationView.frame = CGRectMake(20, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + 20, self.view.frame.size.width - 40, self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height - self.tabBarController.tabBar.frame.size.height - 40);
    _mapInformationView.alpha = 0;
    [self addChildViewController:mapInformationContaienrViewController];
    [self.view addSubview:_mapInformationView];
    
    _hideButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_hideButton addTarget:self
               action:@selector(hideMapInformation:)
     forControlEvents:UIControlEventTouchUpInside];
    [_hideButton setTitle:@"×" forState:UIControlStateNormal];
    [_hideButton.titleLabel setFont:[UIFont systemFontOfSize:30]];
    _hideButton.frame = CGRectMake(23, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + 20 + 3, 40, 40);
    [self.view addSubview:_hideButton];
    _hideButton.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[UIApplication sharedApplication] keyWindow] addSubview:segmentedControl];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    [segmentedControl removeFromSuperview];
}

- (void)onSegmentedControlChanged:(id)sender {
    s_sharedApplication.onSegmentedControlChanged(segmentedControl.selectedSegmentIndex);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    float latitude = newLocation.coordinate.latitude;
    float longitude = newLocation.coordinate.longitude;
    s_sharedApplication.onLocationChanged(latitude, longitude);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        [manager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [locationManager requestStateForRegion:_beaconRegion];
    [locationManager startRangingBeaconsInRegion:_beaconRegion];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (beacons.count > 0) {
        int majors[4];
        int minors[4];
        CLProximity proximities[4];
        for(int i = 0; i < 4; i++){
            if(beacons.count > i){
                majors[i] = ((CLBeacon *)beacons[i]).major.intValue;
                minors[i] = ((CLBeacon *)beacons[i]).minor.intValue;
                proximities[i] = ((CLBeacon *)beacons[i]).proximity;
            }else{
                majors[i] = -1;
                minors[i] = -1;
                proximities[i] = CLProximityUnknown;
            }
        }
        
        if(proximities[0] == CLProximityImmediate) {
            [self oneBeaconWithMajor:majors minor:minors];
        }else if(proximities[0] == CLProximityNear && proximities[1] == CLProximityNear && proximities[2] == CLProximityNear && proximities[3] == CLProximityNear){
            [self fourBeaconsWithMajor:majors minor:minors];
        }else if(proximities[0] == CLProximityNear && proximities[1] == CLProximityNear && proximities[2] == CLProximityNear){
            [self threeBeaconsWithMajor:majors minor:minors];
        }else if(proximities[0] == CLProximityNear && proximities[1] == CLProximityNear){
            [self twoBeaconsWithMajor:majors minor:minors];
        }else if(proximities[0] == CLProximityNear){
            [self oneBeaconWithMajor:majors minor:minors];
        }else if(proximities[0] == CLProximityFar && proximities[1] == CLProximityFar && proximities[2] == CLProximityFar && proximities[3] == CLProximityFar){
            [self fourBeaconsWithMajor:majors minor:minors];
        }else if(proximities[0] == CLProximityFar && proximities[1] == CLProximityFar && proximities[2] == CLProximityFar){
            [self threeBeaconsWithMajor:majors minor:minors];
        }
    }
}

- (void)oneBeaconWithMajor:(int *)majors minor:(int *)minors {
    [_beaconArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:@"major"] intValue] == majors[0] && [[obj objectForKey:@"minor"] intValue] == minors[0]) {
            s_sharedApplication.onLocationBasedBeaconChanged([[obj objectForKey:@"x"] floatValue], [[obj objectForKey:@"y"] floatValue], [[obj objectForKey:@"z"] floatValue]);
            *stop = YES;
        }
    }];
}

- (void)twoBeaconsWithMajor:(int *)majors minor:(int *)minors {
    __block NSDictionary *first;
    __block NSDictionary *second;
    [_beaconArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:@"major"] intValue] == majors[0] && [[obj objectForKey:@"minor"] intValue] == minors[0]) {
            first = obj;
        }else if ([[obj objectForKey:@"major"] intValue] == majors[1] && [[obj objectForKey:@"minor"] intValue] == minors[1]){
            second = obj;
            *stop = YES;
        }
    }];
    float x = ([[first objectForKey:@"x"] floatValue] + [[second objectForKey:@"x"] floatValue])/2;
    float y = ([[first objectForKey:@"y"] floatValue] + [[second objectForKey:@"y"] floatValue])/2;
    float z = [[first objectForKey:@"z"] floatValue];
    s_sharedApplication.onLocationBasedBeaconChanged(x, y, z);
}

- (void)threeBeaconsWithMajor:(int *)majors minor:(int *)minors {
    __block NSDictionary *first;
    __block NSDictionary *second;
    __block NSDictionary *third;
    [_beaconArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:@"major"] intValue] == majors[0] && [[obj objectForKey:@"minor"] intValue] == minors[0]) {
            first = obj;
        }else if ([[obj objectForKey:@"major"] intValue] == majors[1] && [[obj objectForKey:@"minor"] intValue] == minors[1]){
            second = obj;
        }else if ([[obj objectForKey:@"major"] intValue] == majors[2] && [[obj objectForKey:@"minor"] intValue] == minors[2]){
            third = obj;
            *stop = YES;
        }
    }];
    float x = ([[first objectForKey:@"x"] floatValue] + [[second objectForKey:@"x"] floatValue] + [[third objectForKey:@"x"] floatValue])/3;
    float y = ([[first objectForKey:@"y"] floatValue] + [[second objectForKey:@"y"] floatValue] + [[third objectForKey:@"x"] floatValue])/3;
    float z = [[first objectForKey:@"z"] floatValue];
    s_sharedApplication.onLocationBasedBeaconChanged(x, y, z);
}

- (void)fourBeaconsWithMajor:(int *)majors minor:(int *)minors {
    __block NSDictionary *first;
    __block NSDictionary *second;
    __block NSDictionary *third;
    __block NSDictionary *fourth;
    [_beaconArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj objectForKey:@"major"] intValue] == majors[0] && [[obj objectForKey:@"minor"] intValue] == minors[0]) {
            first = obj;
        }else if ([[obj objectForKey:@"major"] intValue] == majors[1] && [[obj objectForKey:@"minor"] intValue] == minors[1]){
            second = obj;
        }else if ([[obj objectForKey:@"major"] intValue] == majors[2] && [[obj objectForKey:@"minor"] intValue] == minors[2]){
            third = obj;
        }else if ([[obj objectForKey:@"major"] intValue] == majors[3] && [[obj objectForKey:@"minor"] intValue] == minors[3]){
            fourth = obj;
            *stop = YES;
        }
    }];
    float x = ([[first objectForKey:@"x"] floatValue] + [[second objectForKey:@"x"] floatValue] + [[third objectForKey:@"x"] floatValue] + [[fourth objectForKey:@"x"] floatValue])/4;
    float y = ([[first objectForKey:@"y"] floatValue] + [[second objectForKey:@"y"] floatValue] + [[third objectForKey:@"x"] floatValue] + [[fourth objectForKey:@"x"] floatValue])/4;
    float z = [[first objectForKey:@"z"] floatValue];
    s_sharedApplication.onLocationBasedBeaconChanged(x, y, z);
}

- (void)showMapInformation:(NSString *)number {
    
    if(_mapInformationView.alpha == 0){
        _mapInformationView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _mapInformationView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             _mapInformationView.alpha = 1.0;
                         }
                         completion:nil];
        
        [UIView animateWithDuration:0.2
                              delay:0.3
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _hideButton.alpha = 1.0;
                         }
                         completion:nil];
    }
    
    [((MapInformationContainerVisualEffectViewController *)self.childViewControllers[0]) changeTitleMapInformationWithNumber:number];
    
    [((MapInformationViewController *)((MapInformationContainerVisualEffectViewController *)self.childViewControllers[0]).childViewControllers[0].childViewControllers[0]) loadDataWithNumber:number];
    
}

- (void)showGoodList {
    
    if(_mapInformationView.alpha == 0){
        _mapInformationView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                            _mapInformationView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                            _mapInformationView.alpha = 1.0;
                        }
                         completion:nil];
        
        [UIView animateWithDuration:0.2
                              delay:0.3
                            options:UIViewAnimationOptionCurveEaseInOut
                        animations:^{
                             _hideButton.alpha = 1.0;
                        }
                         completion:nil];
    }
    
    [((MapInformationContainerVisualEffectViewController *)self.childViewControllers[0]) changeTitleGoodList];
    
    
    [((MapInformationViewController *)((MapInformationContainerVisualEffectViewController *)self.childViewControllers[0]).childViewControllers[0].childViewControllers[0]) loadDataGoodList];
}

- (void)hideMapInformation:(id)sender {
    
    if(_mapInformationView.alpha == 1){
        
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _mapInformationView.transform = CGAffineTransformMakeScale(0.9, 0.9);
                             _mapInformationView.alpha = 0;
                         }
                         completion:nil];
        
        [UIView animateWithDuration:0.1
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             _hideButton.alpha = 0;
                         }
                         completion:nil];
    }
}

// Override to allow orientations other than the default portrait orientation.
// This method is deprecated on ios6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape( interfaceOrientation );
}

// For ios6, use supportedInterfaceOrientations & shouldAutorotate instead
- (NSUInteger) supportedInterfaceOrientations{
#ifdef __IPHONE_6_0
    return UIInterfaceOrientationMaskAllButUpsideDown;
#endif
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    auto glview = cocos2d::Director::getInstance()->getOpenGLView();

    if (glview)
    {
        CCEAGLView *eaglview = (CCEAGLView*) glview->getEAGLView();

        if (eaglview)
        {
            CGSize s = CGSizeMake([eaglview getWidth], [eaglview getHeight]);
            cocos2d::Application::getInstance()->applicationScreenSizeChanged((int) s.width, (int) s.height);
        }
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (IBAction)goodListButton:(id)sender {
    [self showGoodList];
}
@end
