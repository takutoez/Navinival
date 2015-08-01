//
//  SendInformationTableViewController.h
//  Navinival
//
//  Created by 六車卓土 on 7/28/15.
//
//

#import <UIKit/UIKit.h>
#import "StaticDataTableViewController.h"
#import "UIPlaceHolderTextView.h"

@interface SendInformationTableViewController : StaticDataTableViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (UIImage*)imageWithImage:(UIImage*)sourceImage;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *isoDateFormatter;
@property (nonatomic, strong) NSDictionary *dictionary;



@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *setPlaceCell;
@property (weak, nonatomic) IBOutlet UILabel *place;
@property (weak, nonatomic) IBOutlet UITableViewCell *setTimeCell;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *setImageCell;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *memoTextView;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (void)setDictionaryAndSetPlace:(NSDictionary *)dictionary;

- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)datePicked:(id)sender;

@end
