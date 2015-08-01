//
//  SettingsViewController.m
//  Navinival
//
//  Created by 六車卓土 on 2015/04/23.
//
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [_isStudent setOn:[defaults boolForKey:@"IS_STUDENT"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if([self.tableView cellForRowAtIndexPath:indexPath] == _inquiryCell) {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        
        [picker setToRecipients:[NSArray arrayWithObject:@"takutoez@fuji.waseda.jp"]];
        
        [self presentViewController:picker animated:YES completion:nil];
    }

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIAlertController *sentAlert = [UIAlertController alertControllerWithTitle:@"メールを送信しました。" message:@"返信差し上げるまで少々お待ちください。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertController *failedAlert = [UIAlertController alertControllerWithTitle:@"メールの送信に失敗しました。" message:@"インターネット環境をご確認いただき、もう一度お試しください。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [sentAlert dismissViewControllerAnimated:YES completion:nil];
                             [failedAlert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [sentAlert addAction:ok];
    [failedAlert addAction:ok];
    
    switch(result) {
        case MFMailComposeResultCancelled:
            
            
            
            break;
        case MFMailComposeResultSent:
            
            [self presentViewController:sentAlert animated:YES completion:nil];
            
            break;
        case MFMailComposeResultFailed:
            
            [self presentViewController:failedAlert animated:YES completion:nil];
            
            break;
        default:
            break;
    }
}

- (IBAction)isStudent:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(_isStudent.on == YES) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"学院生モードをオンにしました。" message:@"使用上の注意をよく読んでお使いください" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"了解"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        
        [defaults setBool:YES forKey:@"IS_STUDENT"];
    }else{
        [defaults setBool:NO forKey:@"IS_STUDENT"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
