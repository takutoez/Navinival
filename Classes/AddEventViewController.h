//
//  AddPlanController.h
//  mirrorless
//
//  Created by 六車卓土 on 2014/08/11.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Information.h"
#import "StaticDataTableViewController.h"
#import "UIPlaceholderTextView.h"

@interface AddEventViewController : StaticDataTableViewController<UITextFieldDelegate>

@property BOOL edit;
@property BOOL information;
@property BOOL remove;
@property (strong, nonatomic) UIBarButtonItem *cancel;
@property NSDictionary *eventDictionary;
@property NSInteger eventIndex;

@property (weak, nonatomic) IBOutlet UITextField *TitleField;
@property (weak, nonatomic) IBOutlet UITableViewCell *SetTimeCell;
@property (weak, nonatomic) IBOutlet UILabel *Time;
@property (weak, nonatomic) IBOutlet UIDatePicker *Picker;
@property (weak, nonatomic) IBOutlet UITableViewCell *DatePicker;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *MemoTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableViewCell *removeCell;

- (IBAction)datePicker:(id)sender;
- (IBAction)editingChangedTitleField:(id)sender;

@end