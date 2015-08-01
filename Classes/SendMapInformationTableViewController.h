//
//  SendMapInformationTableViewController.h
//  Navinival
//
//  Created by 六車卓土 on 7/27/15.
//
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface SendMapInformationTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendButton;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *contentTextView;
@property (strong, nonatomic)NSString *number;
@property (strong, nonatomic)NSString *informationNumber;
@property (strong, nonatomic)NSString *titleString;
@property (strong, nonatomic)NSString *contentString;
@property Boolean edit;

- (IBAction)send:(id)sender;
- (IBAction)cancel:(id)sender;

@end