//
//  PlaceSearchTableViewController.m
//  Navinival
//
//  Created by 六車卓土 on 7/28/15.
//
//

#import "PlaceSearchTableViewController.h"
#import "SearchResultTableViewController.h"
#import "SendInformationTableViewController.h"
#import "MyAppDelegate.h"

@interface PlaceSearchTableViewController ()

@end

@implementation PlaceSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _result = [NSMutableArray array];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: config delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    [[delegateFreeSession dataTaskWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/gakuin/map/data/", BASE_URL]]
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (error != nil){
                                NSLog(@"Got response %@ with error %@.\n", response, error);
                            }else{
                                NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                _mapArray = [NSMutableArray array];
                                for (NSDictionary *jsonDictionary in jsonArray)
                                {
                                    [_mapArray addObject:jsonDictionary];
                                }
                                [self.tableView reloadData];
                            }
                            
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        }] resume];
    
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"placeResult"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mapArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeCell"];
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    label1.text = [_mapArray[indexPath.row] objectForKey:@"place"];
    
    return cell;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    [self updateFilteredContentForProductName:searchString];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navigationController = (UINavigationController *)self.searchController.searchResultsController;
        
        SearchResultTableViewController *resultViewController = (SearchResultTableViewController *)navigationController.topViewController;
        resultViewController.result = _result;
        [resultViewController.tableView reloadData];
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self updateSearchResultsForSearchController:_searchController];
}

- (void)updateFilteredContentForProductName:(NSString *)name {
    
    // Update the filtered array based on the search text and scope.
    if ((name == nil) || [name length] == 0) {
        _result = [_mapArray mutableCopy];
        // If there is no search string and the scope is chosen.
        NSMutableArray *result = [NSMutableArray array];
        for (NSDictionary *dictionary in _result) {
            [result addObject:dictionary];
        }
        _result = result;
        return;
    }
    
    
    [_result removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (NSDictionary *dictionary in _mapArray) {
        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange productNameRange = NSMakeRange(0, [[dictionary objectForKey:@"place"] length]);
        NSRange foundRange = [[dictionary objectForKey:@"place"] rangeOfString:name options:searchOptions range:productNameRange];
        if (foundRange.length > 0) {
            [_result addObject:dictionary];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [((SendInformationTableViewController *)segue.destinationViewController) setDictionaryAndSetPlace:_mapArray[[self.tableView indexPathForCell:sender].row]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end