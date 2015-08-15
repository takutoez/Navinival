//
//  SearchDetailViewController.h
//  Navinival
//
//  Created by 六車卓土 on 8/15/15.
//
//

#import <UIKit/UIKit.h>

@interface SearchDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) NSString *titleString;
@property (weak, nonatomic) NSString *contentString;
@property (weak, nonatomic) NSString *goodString;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentsView;

@end
