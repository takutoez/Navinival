//
//  MapInformationViewController.h
//  Navinival
//
//  Created by 六車卓土 on 2015/06/26.
//
//

#import <UIKit/UIKit.h>
#import "MyAppDelegate.h"
#import "RootViewController.h"
#import "MapInformationContainerVisualEffectViewController.h"
#import "DetailMapInformationViewController.h"

@interface MapInformationViewController : UITableViewController <UINavigationControllerDelegate>

@property (strong, nonatomic)NSMutableArray *informationArray;

- (void)loadDataWithNumber:(NSString *)number;
- (void)loadDataGoodList;

@end