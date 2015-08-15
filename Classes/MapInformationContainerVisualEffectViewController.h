//
//  MapInformationContainerVisualEffectViewController.h
//  Navinival
//
//  Created by 六車卓土 on 2015/07/17.
//
//

#import <UIKit/UIKit.h>

@interface MapInformationContainerVisualEffectViewController :UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic)NSString *number;
@property (strong, nonatomic)NSString *informationNumber;
@property (strong, nonatomic)NSString *titleString;
@property (strong, nonatomic)NSString *contentString;
@property (weak, nonatomic) IBOutlet UIView *container;

- (void)changeTitleMapInformationWithNumber:(NSString *)number;
- (void)changeTitleGoodList;
- (void)appearStatus: (NSString *)status;
- (void)changeToSend;
- (void)changeToEditWithInformationNumber:(NSString *)informationNumber title:(NSString *)title content:(NSString *)content;
- (IBAction)send:(id)sender;


@end