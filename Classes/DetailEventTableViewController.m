//
//  DetailEventTableViewController.m
//  mirrorless
//
//  Created by 六車卓土 on 2014/08/29.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import "DetailEventTableViewController.h"
#import "EventTitleTableViewCell.h"
#import "AddEventViewController.h"

@interface DetailEventTableViewController (){
    NSArray *array;
    NSDateFormatter *dateFormatter;
    NSDate *date;
}

@end

@implementation DetailEventTableViewController
@synthesize eventArray, eventIndexArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"イベント一覧";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"一覧" style:UIBarButtonItemStylePlain target:nil action:nil];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd HH:mm"];
    date = [dateFormatter dateFromString:@"10/10 9:00"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [eventArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventTitleCell" forIndexPath:indexPath];
    
    NSDictionary *dictionary = [eventArray objectAtIndex:indexPath.section];
    
    NSString *titleString = [dictionary objectForKey:@"TITLE"];
    cell.Title.text = titleString;
    
    NSString *timeString = [dictionary objectForKey:@"TIME"];
    cell.Time.text = timeString;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddEventViewController *addEventViewController = (AddEventViewController *)[segue destinationViewController];
    addEventViewController.edit = YES;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    addEventViewController.eventDictionary = [eventArray objectAtIndex:indexPath.section];
    addEventViewController.eventIndex = [[eventIndexArray objectAtIndex:indexPath.section] intValue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
