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

#import <UIKit/UIKit.h>
#include "HelloWorldScene.h"
#import "MapInformationContainerVisualEffectViewController.h"
#import "MapInformationViewController.h"
#import "Information.h"

@protocol RootViewDelegate <NSObject>

- (void)loadDataWithNumber:(NSString *)number;
- (void)loadDataGoodList;

@end

@interface RootViewController : UIViewController {
    UIWindow *window;
    UISegmentedControl *segmentedControl;
}

@property (strong, nonatomic) id<RootViewDelegate> delegate;

@property (strong, nonatomic) UIView *mapInformationView;
@property (strong, nonatomic) UIButton *hideButton;
- (void)showMapInformation:(NSString *)number;
- (void)showGoodList;

- (IBAction)goodListButton:(id)sender;

@end