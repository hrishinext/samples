//
//  HPTableViewController.m
//  Houseparty
//
//  Created by Hrishi Amravatkar on 11/10/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import "HPTableViewController.h"
#import "HPAPI.h"
#import "HPDataProtocol.h"
#import "HPTableViewCell.h"
#import "NSArray+hpFilters.h"

@interface HPTableViewController ()

@property(nonatomic, readwrite) NSMutableArray<HPData *> *dataList;

@end

@implementation HPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.topViewController.title = @"HouseParty";
    UISwitch *areFriendsSwitch = [[UISwitch alloc] init];
    [areFriendsSwitch addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:areFriendsSwitch];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = item;
    self.dataList = [[NSMutableArray alloc] init];
    HPAPI *hpApi = [[HPAPI alloc] init];
    hpApi.delegate = self;
    [hpApi loadHPData:@"0" successBlock:^(NSArray<HPData *> *hpData) {
        NSLog(@"Success data %@", hpData);
    } withFailure:^(NSError *error) {
        NSLog(@"Error %@", error);
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
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"Cell";
    
    HPTableViewCell *cell = (HPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    HPData *hpData = self.dataList[indexPath.row];
    cell.fromId.text = hpData.from.fromId;
    cell.fromName.text = hpData.from.name;
    cell.toId.text = hpData.to.toId;
    cell.toName.text = hpData.to.name;
    NSString *areFriendsValue = hpData.areFriends ? @"true" : @"false";
    cell.areFriends.text = areFriendsValue;
    NSNumber *doubleNumber = [NSNumber numberWithDouble:hpData.timestamp];
    cell.timestamp.text = [doubleNumber stringValue];
    return cell;
}

- (void)fetchNewData:(NSArray <HPData *>*) data {
    NSLog(@"data %@", data);
    [self.dataList addObjectsFromArray:data];
    self.dataList = [self.dataList getSortedArray];
    [self.tableView reloadData];
}

- (void) action:(UISwitch *)sender {
    BOOL value = sender.on;
    self.dataList = [self.dataList filterByAreFriends:value];
    [self.tableView reloadData];
}

@end
