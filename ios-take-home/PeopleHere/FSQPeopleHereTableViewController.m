//
//  FSQPeopleHereTableViewController.m
//  ios-interview
//
//  Created by Samuel Grossberg on 3/17/16.
//  Copyright © 2016 Foursquare. All rights reserved.
//

#import "FSQPeopleHereTableViewController.h"
#import "FSQVenueApi.h"
#import "FSQVenue.h"
#import "FSQVisitor.h"
#import "FSQPeopleCellTableViewCell.h"

@interface FSQPeopleHereTableViewController ()

@property(nonatomic, retain) FSQVenue *fsqVenue;

@end

@implementation FSQPeopleHereTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.topViewController.title = @"Visitors";

    FSQVenueApi *venueApi = [[FSQVenueApi alloc] init];
    [venueApi getVenueInfo:^(FSQVenue *fsqVenueData) {
        self.fsqVenue = fsqVenueData;
        [self.tableView reloadData];
    } withFailure:^(NSError *error) {
        //error
    }];
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
    return [self.fsqVenue.visitors count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    FSQPeopleCellTableViewCell *cell = (FSQPeopleCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FSQPeopleCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    FSQVisitor *visitor = self.fsqVenue.visitors[indexPath.row];
    if ([visitor.visitorId isEqualToString:@"-1"]) {
        cell.visitorName.textColor = [UIColor grayColor];
        cell.timeText.textColor = [UIColor grayColor];
    }
    cell.visitorName.text = visitor.name;
    cell.timeText.text = [NSString stringWithFormat:@"%@ - %@", [self timeFormatted:visitor.arriveTime], [self timeFormatted:visitor.leaveTime]];
    return cell;
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d",hours, minutes];
}

@end
