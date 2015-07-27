//
//  InformationDetailViewController.h
//  Navinival
//
//  Created by 六車卓土 on 2015/04/23.
//
//

#import <UIKit/UIKit.h>
#import "Information.h"

@interface InformationDetailViewController : UIViewController

@property Information *info;
@property UIImage *image;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *detailMeta;
@property (weak, nonatomic) IBOutlet UILabel *detailContents;

@end