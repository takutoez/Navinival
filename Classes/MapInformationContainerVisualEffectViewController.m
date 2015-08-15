//
//  MapInformationContainerVisualEffectViewController.m
//  Navinival
//
//  Created by 六車卓土 on 2015/07/17.
//
//

#import "MapInformationContainerVisualEffectViewController.h"
#import "SendMapInformationTableViewController.h"

@interface MapInformationContainerVisualEffectViewController ()

@end

@implementation MapInformationContainerVisualEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTitleGoodList {
    _titleLabel.text = @"Goodリスト";
    _statusLabel.hidden = YES;
    _rightButton.hidden = YES;
}

- (void)changeTitleMapInformationWithNumber:(NSString *)number {
    _number = number;
    _titleLabel.text = @"マップ情報";
    _statusLabel.hidden = YES;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults boolForKey:@"IS_STUDENT"]) {
        _rightButton.hidden = NO;
    }else{
        _rightButton.hidden = YES;
    }
}

- (void)appearStatus:(NSString *)status {
    _statusLabel.text = status;
    _statusLabel.hidden = NO;
}

- (void)changeToSend {
    _rightButton.titleLabel.text = @"送信";
}

- (void)changeToEditWithInformationNumber:(NSString *)informationNumber title:(NSString *)title content:(NSString *)content {
    _informationNumber = informationNumber;
    _titleString = title;
    _contentString = content;
    _rightButton.titleLabel.text = @"編集";
}

- (IBAction)send:(id)sender {
    UINavigationController *sendMapInformationTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sendMapInformation"];
    ((SendMapInformationTableViewController *)sendMapInformationTableViewController.childViewControllers[0]).number = _number;
    if([_rightButton.titleLabel.text isEqualToString:@"編集"]) {
        ((SendMapInformationTableViewController *)sendMapInformationTableViewController.childViewControllers[0]).informationNumber = _informationNumber;
        ((SendMapInformationTableViewController *)sendMapInformationTableViewController.childViewControllers[0]).titleString = _titleString;
        ((SendMapInformationTableViewController *)sendMapInformationTableViewController.childViewControllers[0]).contentString = _contentString;
        ((SendMapInformationTableViewController *)sendMapInformationTableViewController.childViewControllers[0]).edit = YES;
    }
    [self presentViewController:sendMapInformationTableViewController animated:YES completion:nil];
}

@end
