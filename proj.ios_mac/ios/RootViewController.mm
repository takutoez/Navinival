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
    NSArray *itemArray = [NSArray arrayWithObjects: @"1階", @"2階", @"3階", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(20, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height - 34, self.view.frame.size.width - 40, 30);
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
    _hideButton.alpha = 0;
    [self.view addSubview:_hideButton];
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
    
    [((MapInformationContainerVisualEffectViewController *)self.childViewControllers[0]) changeTitleMapInformation];
    
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
