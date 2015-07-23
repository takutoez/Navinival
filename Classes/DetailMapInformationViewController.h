//
//  DetailMapInformationViewController.h
//  Navinival
//
//  Created by 六車卓土 on 7/21/15.
//
//

#import <UIKit/UIKit.h>
#import "MyAppDelegate.h"

@interface DetailMapInformationViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *contentsView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) NSString *mapNumber;
@property (weak, nonatomic) NSString *informationNumber;
@property (weak, nonatomic) NSString *titleString;
@property (weak, nonatomic) NSString *contentString;
@property (weak, nonatomic) NSString *goodString;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *good;

@end