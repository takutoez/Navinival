//
//  SecondDayTableViewController.h
//  mirrorless
//
//  Created by 六車卓土 on 2014/08/29.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondDayTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)halfTimeButton:(id)sender;
- (IBAction)justTimeButton:(id)sender;

@end
