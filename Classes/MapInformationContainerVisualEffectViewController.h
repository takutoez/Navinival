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
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)changeTitleMapInformation;
- (void)changeTitleGoodList;
- (void)appearStatus: (NSString *)status;

@end