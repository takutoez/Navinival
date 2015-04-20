//
//  SecondViewController.m
//  mirrorless
//
//  Created by 六車卓土 on 2014/03/26.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import "ThirdViewController.h"
#import "FirstDayTableViewController.h"
#import "SecondDayTableViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController
@synthesize info;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)doneAddEventUnwind:(UIStoryboardSegue *)segue{
    [((FirstDayTableViewController *)self.childViewControllers[0]).tableView reloadData];
    [((SecondDayTableViewController *)self.childViewControllers[1]).tableView reloadData];
}

- (IBAction)cancelAddEventUnwind:(UIStoryboardSegue *)segue{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end