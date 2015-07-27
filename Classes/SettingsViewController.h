//
//  SettingsViewController.h
//  Navinival
//
//  Created by 六車卓土 on 2015/04/23.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *isStudent;
@property (weak, nonatomic) IBOutlet UITableViewCell *inquiryCell;

- (IBAction)isStudent:(id)sender;

@end