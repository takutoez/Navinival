//
//  StaticTableViewController.h
//  StaticTableViewController 2.0
//
//  Created by Peter Paulis on 31.1.2013.
//  Copyright (c) 2013 Peter Paulis. All rights reserved.
//

/*
 * Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>

@interface StaticDataTableViewController : UITableViewController

@property (nonatomic, assign) BOOL hideSectionsWithHiddenRows;

- (BOOL)cellIsHidden:(UITableViewCell *)cell;

- (void)updateCell:(UITableViewCell *)cell;

- (void)updateCells:(NSArray *)cells;

- (void)cell:(UITableViewCell *)cell setHidden:(BOOL)hidden;

- (void)cells:(NSArray *)cells setHidden:(BOOL)hidden;

// never call [self.tableView reloadData] directly
// doing so will lead to data inconsistenci
// always use this method for reload
- (void)reloadDataAnimated:(BOOL)animated;

@end
