//
//  DetailEventTableViewController.h
//  mirrorless
//
//  Created by 六車卓土 on 2014/08/29.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailEventTableViewController : UITableViewController

@property NSArray* eventArray;
@property NSArray* eventIndexArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end