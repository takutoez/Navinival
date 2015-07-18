//
//  FirstDayTableViewController.h
//  mirrorless
//
//  Created by 六車卓土 on 2014/08/27.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstDayTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)halfTimeButton:(id)sender;
- (IBAction)justTimeButton:(id)sender;

@end