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
@synthesize pinX, pinY, cancel, edit, information, remove, eventDictionary, eventIndex;

int placeTapCounter;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self toggleCellVissibility:self.DatePicker animated:NO];
    [self toggleCellVissibility:self.PlacePicker animated:NO];
    self.MemoTextView.placeholder = @"メモ";
    
    self.PlaceSwitch.on = NO;
    
    self.doneButton.enabled = NO;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"M/d H:mm"];
    [self.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"]];
    
    placeTapCounter = 0;
    
    if(edit){
        self.navigationItem.title = @"イベントを編集";
        self.TitleField.text = [eventDictionary objectForKey:@"TITLE"];
        self.Time.text = [eventDictionary objectForKey:@"TIME"];
        pinX = [[eventDictionary objectForKey:@"X"] floatValue];
        pinY = [[eventDictionary objectForKey:@"Y"] floatValue];
        self.MemoTextView.text = [eventDictionary objectForKey:@"CONTENT"];
        self.Picker.date = [self.dateFormatter dateFromString:self.Time.text];
        NSLog(@"%@", [self.dateFormatter dateFromString:self.Time.text]);
        self.doneButton.enabled = YES;
        if(pinX < 1000000.0f && pinY < 1000000.0f) self.PlaceSwitch.on = YES;
    }else{
        [self toggleCellVissibility:self.removeCell animated:NO];
        if(information){
            self.TitleField.text = [eventDictionary objectForKey:@"TITLE"];
            self.Time.text = [eventDictionary objectForKey:@"TIME"];
            pinX = [[eventDictionary objectForKey:@"X"] floatValue];
            pinY = [[eventDictionary objectForKey:@"Y"] floatValue];
            self.MemoTextView.text = [eventDictionary objectForKey:@"CONTENT"];
            self.Picker.date = [self.dateFormatter dateFromString:self.Time.text];
            NSLog(@"%@", [self.dateFormatter dateFromString:self.Time.text]);
            self.doneButton.enabled = YES;
            if(pinX < 1000000.0f && pinY < 1000000.0f && pinX != 0.0f && pinY != 0.0f) self.PlaceSwitch.on = YES;
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
    if(indexPath.section == 1 && indexPath.row == 0){
        [self toggleCellVissibility:self.PlacePicker animated:YES];
        placeTapCounter++;
        if(!self.PlaceSwitch.on)
            self.PlaceSwitch.on = YES;
    }
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
        Information *info = [Information title:self.TitleField.text time:self.Time.text content:self.MemoTextView.text image:@""];
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

- (IBAction)placeSwitch:(id)sender {
    if(placeTapCounter % 2 != 0 || placeTapCounter == 0){
    [self toggleCellVissibility:self.PlacePicker animated:YES];
    placeTapCounter++;
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