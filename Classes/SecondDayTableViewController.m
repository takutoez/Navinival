//
//  FirstDayTableViewController.m
//  mirrorless
//
//  Created by 六車卓土 on 2014/08/27.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import "SecondDayTableViewController.h"
#import "EventTableViewCell.h"
#import "DetailEventTableViewController.h"

@interface SecondDayTableViewController (){
    NSDateFormatter *dateFormatter;
    NSDate *date;
    NSArray *array;
    NSArray *sendingArray;
    NSArray *sendingIndexArray;
}

@end

@implementation SecondDayTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd H:mm"];
    date = [dateFormatter dateFromString:@"10/11 9:00"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger justTimeCounter = 0, halfTimeCounter = 0;
    array = [[NSUserDefaults standardUserDefaults] arrayForKey:@"EVENTS"];
    NSMutableArray *justArray = [NSMutableArray array];
    NSMutableArray *halfArray = [NSMutableArray array];
    NSMutableArray *justIndexArray = [NSMutableArray array];
    NSMutableArray *halfIndexArray = [NSMutableArray array];
    EventTableViewCell *cell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"SecondDayEventCell"];
    int i = 0;
    for(NSDictionary *dictionary in array){
        float secondGap = [[dateFormatter dateFromString:[dictionary objectForKey:@"TIME"]] timeIntervalSinceDate:date];
        NSString *baseString = [dictionary objectForKey:@"TITLE"];
        NSString *contentString = [dictionary objectForKey:@"CONTENT"];
        if(indexPath.row - 0.25 < secondGap / 3600 && indexPath.row + 0.25 > secondGap / 3600){
            [cell.JustTime setTitle:baseString forState:UIControlStateNormal];
            cell.JustTimeSubLabel.text = contentString;
            justTimeCounter++;
            if(justTimeCounter != 1){
                [cell.JustOthers setText:[NSString stringWithFormat:@"他%zd件", justTimeCounter-1]];
            }
            [justArray addObject:dictionary];
            [justIndexArray addObject:[NSNumber numberWithInt:i]];
        }else if(indexPath.row - 0.25 > secondGap / 3600 && indexPath.row - 0.75 < secondGap / 3600){
            [cell.HalfTime setTitle:baseString forState:UIControlStateNormal];
            cell.HalfTimeSubLabel.text = contentString;
            halfTimeCounter++;
            if(halfTimeCounter != 1){
                [cell.HalfOthers setText:[NSString stringWithFormat:@"他%zd件", halfTimeCounter-1]];
            }
            [halfArray addObject:dictionary];
            [halfIndexArray addObject:[NSNumber numberWithInt:i]];
        }
        i++;
    }
    [cell.JustTime setValue:justArray forKey:@"array"];
    [cell.HalfTime setValue:halfArray forKey:@"array"];
    [cell.JustTime setValue:justIndexArray forKey:@"indexArray"];
    [cell.HalfTime setValue:halfIndexArray forKey:@"indexArray"];
    if(justTimeCounter == 0){
        cell.JustTime.hidden = YES;
        cell.JustTime.enabled = NO;
        cell.JustTimeSubLabel.hidden = YES;
    }else{
        cell.JustTime.hidden = NO;
        cell.JustTime.enabled = YES;
        cell.JustTimeSubLabel.hidden = NO;
    }
    if(justTimeCounter == 1){
        cell.JustOthers.text = @"";
    }
    if(halfTimeCounter == 0){
        cell.HalfTime.hidden = YES;
        cell.HalfTime.enabled = NO;
        cell.HalfTimeSubLabel.hidden = YES;
    }else{
        cell.HalfTime.hidden = NO;
        cell.HalfTime.enabled = YES;
        cell.HalfTimeSubLabel.hidden = NO;
    }
    if(halfTimeCounter == 1){
        cell.HalfOthers.text = @"";
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    DetailEventTableViewController *detailEventViewController = (DetailEventTableViewController *)[segue destinationViewController];
    detailEventViewController.eventArray = sendingArray;
    detailEventViewController.eventIndexArray = sendingIndexArray;
}

- (IBAction)halfTimeButton:(id)sender {
    sendingArray = [sender valueForKeyPath:@"array"];
    sendingIndexArray = [sender valueForKeyPath:@"indexArray"];
    [self performSegueWithIdentifier:@"ToDetailEventSegue2" sender:self];
}

- (IBAction)justTimeButton:(id)sender {
    sendingArray = [sender valueForKeyPath:@"array"];
    sendingIndexArray = [sender valueForKeyPath:@"indexArray"];
    [self performSegueWithIdentifier:@"ToDetailEventSegue2" sender:self];
}
@end