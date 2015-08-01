//
//  PlaceSearchTableViewController.h
//  Navinival
//
//  Created by 六車卓土 on 7/28/15.
//
//

#import <UIKit/UIKit.h>

@interface PlaceSearchTableViewController : UITableViewController <UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic)NSMutableArray *mapArray;
@property (nonatomic, strong) NSMutableArray *result;
@property (strong, nonatomic) UISearchController *searchController;

- (IBAction)cancel:(id)sender;

@end