//
//  AddPlanController.m
//  mirrorless
//
//  Created by 六車卓土 on 2014/08/11.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import "AddEventViewController.h"
#import "FirstDayTableViewController.h"
#import "SecondDayTableViewController.h"
#import "PlanViewController.h"

@interface AddEventViewController (){
    
}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation AddEventViewController
@synthesize cancel, edit, information, remove, eventDictionary, eventIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self toggleCellVissibility:self.DatePicker animated:NO];
    self.MemoTextView.placeholder = @"メモ";
    
    self.doneButton.enabled = NO;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"M/d H:mm"];
    [self.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    if(edit){
        self.navigationItem.title = @"イベントを編集";
        self.TitleField.text = [eventDictionary objectForKey:@"TITLE"];
        self.Time.text = [eventDictionary objectForKey:@"TIME"];
        self.MemoTextView.text = [eventDictionary objectForKey:@"CONTENT"];
        self.Picker.date = [self.dateFormatter dateFromString:self.Time.text];
        NSLog(@"%@", [self.dateFormatter dateFromString:self.Time.text]);
        self.doneButton.enabled = YES;
    }else{
        [self toggleCellVissibility:self.removeCell animated:NO];
        if(information){
            self.TitleField.text = [eventDictionary objectForKey:@"TITLE"];
            self.Time.text = [eventDictionary objectForKey:@"TIME"];
            self.MemoTextView.text = [eventDictionary objectForKey:@"CONTENT"];
            self.Picker.date = [self.dateFormatter dateFromString:self.Time.text];
            NSLog(@"%@", [self.dateFormatter dateFromString:self.Time.text]);
            self.doneButton.enabled = YES;
        }
        cancel =
        [[UIBarButtonItem alloc]
         initWithTitle:@"キャンセル"  // ボタンタイトル名を指定
         style:UIBarButtonItemStylePlain  // スタイルを指定（※下記表参照）
         target:self  // デリゲートのターゲットを指定
         action:@selector(cancel:)  // ボタンが押されたときに呼ばれるメソッドを指定
         ];
        self.navigationItem.leftBarButtonItem = cancel;
    }
}

- (void) toggleCellVissibility:(UITableViewCell *)cell animated:(BOOL)animate{
    [self cell:cell setHidden:![self cellIsHidden:cell]];
    [self reloadDataAnimated:animate];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && indexPath.row == 1)
        [self toggleCellVissibility:self.DatePicker animated:YES];

    if(indexPath.section == 2){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults arrayForKey:@"EVENTS"];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
        [mutableArray removeObjectAtIndex:eventIndex];
        [userDefaults setObject:mutableArray forKey:@"EVENTS"];
        [userDefaults synchronize];
        remove = YES;
        [self removeNotification:eventIndex];
        [self performSegueWithIdentifier:@"doneAddEventUnwind" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"doneAddEventUnwind"] && !remove){
        Information *info = [Information title:self.TitleField.text map:nil time:self.Time.text content:self.MemoTextView.text image:nil good:nil];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *array = [userDefaults arrayForKey:@"EVENTS"];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        
        if(edit){
            [mutableArray removeObjectAtIndex:eventIndex];
        }
    
        [dictionary setObject:info.title forKey:@"TITLE"];
        [dictionary setObject:info.time forKey:@"TIME"];
        [dictionary setObject:[self.dateFormatter stringFromDate:[self.Picker.date dateByAddingTimeInterval:-300]] forKey:@"SET_TIME"];
        [dictionary setObject:info.content forKey:@"CONTENT"];
        [mutableArray addObject:dictionary];
        [userDefaults setObject:mutableArray forKey:@"EVENTS"];
        [userDefaults synchronize];
        
        [self removeNotification:eventIndex];
        
        UILocalNotification *notify = [[UILocalNotification alloc] init];
        
        notify.fireDate = [self.Picker.date dateByAddingTimeInterval:-300];
        notify.timeZone = [NSTimeZone defaultTimeZone];
        notify.hasAction = YES;
        NSLog(@"%@", self.TitleField.text);
        notify.alertBody = self.TitleField.text;
        notify.alertAction = @"起動する";
        notify.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notify];

    }
}

- (void)removeNotification:(NSInteger)deleteId
{
    int keyId = 0;
    for (UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        keyId = [[notify.userInfo objectForKey:@"key_id"] intValue];
        if( deleteId == keyId ){
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
        }
    }
}

- (IBAction)datePicker:(id)sender
{
    UIDatePicker *targetedDatePicker = sender;
    self.Time.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    NSLog(@"%@", [self.dateFormatter stringFromDate:targetedDatePicker.date]);
    if(![self.TitleField.text isEqualToString:@""] && ![self.Time.text isEqualToString:@"未設定"]){
        self.doneButton.enabled = YES;
    }else{
        self.doneButton.enabled = NO;
    }
}

- (IBAction)editingChangedTitleField:(id)sender {
    if(![self.TitleField.text isEqualToString:@""] && ![self.Time.text isEqualToString:@"未設定"]){
        self.doneButton.enabled = YES;
    }else{
        self.doneButton.enabled = NO;
    }
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.TitleField resignFirstResponder];
    return NO;
}

@end