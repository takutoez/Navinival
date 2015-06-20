//
//  InformationViewController.m
//  Navinival
//
//  Created by 六車卓土 on 2015/04/23.
//
//

#import "InformationViewController.h"
#import "Information.h"
#import "MyAppDelegate.h"
#import "InformationDetailViewController.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl* refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshControlStateChanged:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self getInformationData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCell"];
    
    Information *info = [_array objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[info title]];
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"%@", [info time]]];
    
    return cell;
}

- (void)getInformationData {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    [[delegateFreeSession dataTaskWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/information/", BASE_URL]]
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (error != nil){
                                NSLog(@"Got response %@ with error %@.\n", response, error);
                            }else{
                                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                _array = [NSMutableArray array];
                                for (NSDictionary *jsonDictionary in jsonArray)
                                {
                                    [_array addObject:[Information title:[jsonDictionary objectForKey:@"title"] time:[jsonDictionary objectForKey:@"time"] content:[jsonDictionary objectForKey:@"content"] image:[NSString stringWithFormat:@"%@%@", BASE_URL, [jsonDictionary objectForKey:@"image"]]]];
                                }
                                [[self tableView] reloadData];
                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                                    [self getImageData];
                                });
                            }
                        }] resume];
    [self.refreshControl endRefreshing];
}

-(void)getImageData {
    _imageArray = [NSMutableArray array];
    for (Information *info in _array){
        [_imageArray addObject:[UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: info.image]]]];
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath*) indexPath{
    [self performSegueWithIdentifier:@"detail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    InformationDetailViewController *destinationViewController = (InformationDetailViewController*)[segue destinationViewController];
    destinationViewController.info  = [_array objectAtIndex:indexPath.row];
    if (_imageArray.count > indexPath.row){
        destinationViewController.image = [_imageArray objectAtIndex:indexPath.row];
    }
}

- (void)refreshControlStateChanged:(id)sender{
    [self getInformationData];
}

@end
