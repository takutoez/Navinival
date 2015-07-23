//
//  MapInformationContainerVisualEffectViewController.m
//  Navinival
//
//  Created by 六車卓土 on 2015/07/17.
//
//

#import "MapInformationContainerVisualEffectViewController.h"

@interface MapInformationContainerVisualEffectViewController ()

@end

@implementation MapInformationContainerVisualEffectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTitleGoodList {
    _titleLabel.text = @"Goodリスト";
    _statusLabel.hidden = YES;
}

- (void)changeTitleMapInformation {
    _titleLabel.text = @"マップ情報";
    _statusLabel.hidden = YES;
}

- (void)appearStatus:(NSString *)status {
    _statusLabel.text = status;
    _statusLabel.hidden = NO;
}

@end
