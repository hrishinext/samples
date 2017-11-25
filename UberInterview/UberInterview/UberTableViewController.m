//
//  UberTableViewController.m
//  UberInterview
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import "UberTableViewController.h"
#import "UberApi.h"
#import "UberTableViewCell.h"
#import "UberVenue.h"
#import "NSArray+sort.h"

@interface UberTableViewController ()

@property(nonatomic, readwrite) NSArray<UberVenue *> *venueList;
@property(nonatomic, readwrite) NSString *searchString;

@end

@implementation UberTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.venueSearchBar.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.venueList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    UberTableViewCell *cell = (UberTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.venueImageView.image = nil;
    UberVenue *venueData = self.venueList[indexPath.row];
    cell.venueName.text = venueData.name;
    cell.veneueAddress.text = venueData.address;
    cell.venuePhoneNo.text = venueData.phoneNumber;
    cell.venueDistance.text = [NSString stringWithFormat:@"%ld",venueData.distance];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:venueData.imageUrlString]];
        UIImage *image = [UIImage imageWithData:imageData];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            UberTableViewCell *updateCell = (id)[self.tableView cellForRowAtIndexPath:indexPath];
            if (updateCell) {
                updateCell.venueImageView.image = image;
                updateCell.venueImageView.image = [updateCell.venueImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [updateCell.venueImageView setTintColor:[UIColor blueColor]];
            }
        });
    });
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchString = searchText;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateSearch) object:nil];
    [self performSelector:@selector(updateSearch) withObject:nil afterDelay:1];
}

-(void) updateSearch {
    UberApi *uberApi = [[UberApi alloc] init];
    [uberApi searchVenues:self.searchString successBlock:^(NSArray<UberVenue *> *inputVenueList) {
        self.venueList = [inputVenueList getSortedArray];
        dispatch_async(dispatch_get_main_queue(),^{
            [self.tableView reloadData];
        });
    } withFailure:^(NSError *failure) {
        NSLog(@"failure");
    }];
}
@end
