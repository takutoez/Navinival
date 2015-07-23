//
//  DetailMapInformationViewController.m
//  Navinival
//
//  Created by 六車卓土 on 7/21/15.
//
//

#import "DetailMapInformationViewController.h"

@interface DetailMapInformationViewController ()

@end

@implementation DetailMapInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+1Good" style:UIBarButtonItemStylePlain target:self action:@selector(goodAdded)];
    
    self.navigationItem.title = _titleString;
    _content.text = _contentString;
    [_content sizeToFit];
    _good.text = [NSString stringWithFormat:@"%@%@",  _goodString, @"Goods"];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_scrollView layoutIfNeeded];
    _contentsView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, _content.frame.origin.y + _content.frame.size.height + 46);
    _scrollView.contentSize = _contentsView.bounds.size;
}

- (void)goodAdded {
    
    self.navigationItem.rightBarButtonItem.title = @"処理中";
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSData *data = [[NSString stringWithFormat:@"map_number=%@&information_number=%@", _mapNumber, _informationNumber] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", [NSString stringWithFormat:@"map_number=%@&information_number=%@", _mapNumber, _informationNumber]);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/form/good/", BASE_URL]]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = data;
    
    [[delegateFreeSession dataTaskWithRequest:request
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (error != nil){
                                NSLog(@"Got response %@ with error %@.\n", response, error);
                            }else{
                                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                for (NSDictionary *jsonDictionary in jsonArray)
                                {
                                    if([[jsonDictionary objectForKey:@"status"] isEqualToString:@"OK"]){
                                        self.navigationItem.rightBarButtonItem.title = @"Good済み";
                                        _good.text = [NSString stringWithFormat:@"%ld%@",  [_goodString integerValue]+1, @"Goods"];
                                    }
                                }
                            }
                        }] resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
