//
//  SearchResultTableViewController.m
//  Navinival
//
//  Created by 六車卓土 on 7/28/15.
//
//

#import "SearchResultTableViewController.h"
#import "SendInformationTableViewController.h"

@interface SearchResultTableViewController ()

@end

@implementation SearchResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_result count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultCell"];
    
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    label1.text = [_result[indexPath.row] objectForKey:@"place"];
    
    return cell;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [((SendInformationTableViewController *)segue.destinationViewController) setDictionaryAndSetPlace:_result[[self.tableView indexPathForCell:sender].row]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
