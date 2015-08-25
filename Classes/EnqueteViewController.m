//
//  EnqueteViewController.m
//  Navinival
//
//  Created by 六車卓土 on 8/20/15.
//
//

#import "EnqueteViewController.h"
#import "MyAppDelegate.h"

@interface EnqueteViewController ()

@end

@implementation EnqueteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/enquete/", BASE_URL]]];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if([request.URL.host isEqualToString:@"close"]){
        [self close];
    }
    return YES;
}

- (void)close {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DID_ENQUETE"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)later:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
