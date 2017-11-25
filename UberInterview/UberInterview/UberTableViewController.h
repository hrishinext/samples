//
//  UberTableViewController.h
//  UberInterview
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UberTableViewController : UITableViewController<UISearchBarDelegate>

@property(nonatomic, weak) IBOutlet UISearchBar *venueSearchBar;

@end
