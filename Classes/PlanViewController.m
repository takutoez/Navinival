//
//  SecondViewController.m
//  mirrorless
//
//  Created by 六車卓土 on 2014/03/26.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import "PlanViewController.h"
#import "FirstDayTableViewController.h"
#import "SecondDayTableViewController.h"

@interface PlanViewController ()

@end

@implementation PlanViewController
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

- (IBAction)addEvent:(id)sender {
    
    UINavigationController *addEventNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"addEventNavigation"];
    [self presentViewController:addEventNavigationController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end