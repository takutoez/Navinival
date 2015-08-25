//
//  EnqueteViewController.h
//  Navinival
//
//  Created by 六車卓土 on 8/20/15.
//
//

#import <UIKit/UIKit.h>

@interface EnqueteViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)later:(id)sender;

@end
