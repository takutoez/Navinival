//
//  MapInformationViewController.m
//  Navinival
//
//  Created by 六車卓土 on 2015/06/26.
//
//

#import "MapInformationViewController.h"

@interface MapInformationViewController () <RootViewDelegate>

@end

@implementation MapInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_informationArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    UILabel *label2 = (UILabel*)[cell viewWithTag:2];
    UILabel *label3 = (UILabel*)[cell viewWithTag:3];

    label1.text = [NSString stringWithFormat: @"%ld", (long)indexPath.row+1];
    label2.text = [[_informationArray objectAtIndex:indexPath.row] objectForKey:@"title"];
    label3.text = [NSString stringWithFormat:@"%@%@", [[[_informationArray objectAtIndex:indexPath.row] objectForKey:@"good"] stringValue], @"Goods"];
    
    return cell;
}

- (void)loadDataWithNumber:(NSString *)number {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    [[delegateFreeSession dataTaskWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/map/information/%@/", BASE_URL, number]]
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (error != nil){
                                NSLog(@"Got response %@ with error %@.\n", response, error);
                            }else{
                                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                _informationArray = [NSMutableArray array];
                                if(jsonArray.count != 0){
                                    for (NSDictionary *jsonDictionary in jsonArray)
                                    {
                                        [_informationArray addObject:jsonDictionary];
                                    }
                                }else{
                                    [((MapInformationContainerVisualEffectViewController *)self.parentViewController.parentViewController) appearStatus:@"情報がありません"];
                                }
                                [self.tableView reloadData];
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            }
                        }] resume];
}

- (void)loadDataGoodList {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    [[delegateFreeSession dataTaskWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/good/", BASE_URL]]
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (error != nil){
                                NSLog(@"Got response %@ with error %@.\n", response, error);
                            }else{
                                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                _informationArray = [NSMutableArray array];
                                if(jsonArray.count != 0){
                                    for (NSDictionary *jsonDictionary in jsonArray)
                                    {
                                        [_informationArray addObject:jsonDictionary];
                                    }
                                }else{
                                    [((MapInformationContainerVisualEffectViewController *)self.parentViewController.parentViewController) appearStatus:@"情報がありません"];
                                }
                                [self.tableView reloadData];
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                            }
                        }] resume];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    DetailMapInformationViewController *destinationViewController = [segue destinationViewController];
    destinationViewController.mapNumber = [[_informationArray objectAtIndex:indexPath.row]objectForKey:@"map"];
    destinationViewController.informationNumber = [[_informationArray objectAtIndex:indexPath.row]objectForKey:@"number"];
    destinationViewController.titleString = [[_informationArray objectAtIndex:indexPath.row]objectForKey:@"title"];
    destinationViewController.contentString = [[_informationArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    destinationViewController.goodString = [[[_informationArray objectAtIndex:indexPath.row] objectForKey:@"good"] stringValue];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
