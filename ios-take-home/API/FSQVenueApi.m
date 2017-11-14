//
//  FSQVenueApi.m
//  ios-interview
//
//  Created by Hrishi Amravatkar on 11/13/17.
//  Copyright © 2017 Foursquare. All rights reserved.
//

#import "FSQVenueApi.h"
#import "FSQVenue.h"
#import "FSQVisitor.h"

@implementation FSQVenueApi

-(void)getVenueInfo:(void (^)(FSQVenue *))success withFailure:(void(^)(NSError *))failure {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"people-here" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error == nil) {
        NSDictionary *venueDict = [dict objectForKey:@"venue"];
        FSQVenue *fsqVenue = [[FSQVenue alloc] init];
        fsqVenue.venueId = [venueDict objectForKey:@"id"];
        fsqVenue.name = [venueDict objectForKey:@"name"];
        fsqVenue.openTime = [[venueDict objectForKey:@"openTime"] intValue];
        fsqVenue.closeTime = [[venueDict objectForKey:@"closeTime"] intValue];
        NSArray *visitorsList = [venueDict objectForKey:@"visitors"];
        NSMutableArray *visitors = [[NSMutableArray alloc] init];
        for (int i = 0; i < [visitorsList count]; i++) {
            NSDictionary *visitorDict = visitorsList[i];
            FSQVisitor *fsqVisitor = [[FSQVisitor alloc] init];
            fsqVisitor.visitorId = [visitorDict objectForKey:@"id"];
            fsqVisitor.name = [visitorDict objectForKey:@"name"];
            fsqVisitor.arriveTime = [[visitorDict objectForKey:@"arriveTime"] intValue];
            fsqVisitor.leaveTime = [[visitorDict objectForKey:@"leaveTime"] intValue];
            [visitors addObject:fsqVisitor];
        }
        fsqVenue.visitors = visitors;
        FSQVenue *newVenue = [self orderVisitors:fsqVenue];
        success(newVenue);
    }
    else {
        failure(error);
    }
}

//Here we first sort visitors array based on the arrival time.
//For performance reasons, iterate once through the sorted array of visitors.
//Start with the venue opentime and closetime
//Start filling the gap between venue opentime to visitor arrival time
//Start filling the gap towards end with visitor leave time and venue close time.
//return the newly formed visitors object
- (FSQVenue *) orderVisitors:(FSQVenue *)fsqVenue {
    FSQVenue *outputVenue = [[FSQVenue alloc] init];
    outputVenue.venueId = fsqVenue.venueId;
    outputVenue.name = fsqVenue.name;
    //Sort by arrival time
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey: @"arriveTime" ascending: YES];
    NSArray *sortedArray = [fsqVenue.visitors sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    //Now fill in the gap
    NSMutableArray *visitorsOutput = [[NSMutableArray alloc] init];
    int currentOpenTime = fsqVenue.openTime;
    int currentCloseTime = fsqVenue.closeTime;
    for(int i = 0; i < [sortedArray count]; i++) {
        FSQVisitor *currentVisitor = sortedArray[i];
        if (currentOpenTime < currentVisitor.arriveTime) {
            FSQVisitor *noVisitor = [[FSQVisitor alloc] init];
            noVisitor.visitorId = @"-1";
            noVisitor.name = @"No Visitor";
            noVisitor.arriveTime = currentOpenTime;
            noVisitor.leaveTime = currentVisitor.arriveTime;
            [visitorsOutput addObject:noVisitor];
        }
        [visitorsOutput addObject:currentVisitor];
        if (i == [sortedArray count]-1) {
            if (currentVisitor.leaveTime < currentCloseTime) {
                FSQVisitor *noVisitor = [[FSQVisitor alloc] init];
                noVisitor.visitorId = @"-1";
                noVisitor.name = @"No Visitor";
                noVisitor.arriveTime = currentVisitor.leaveTime;
                noVisitor.leaveTime = currentCloseTime;
                [visitorsOutput addObject:noVisitor];
            }
        }
        currentOpenTime = currentVisitor.leaveTime;
    }
    outputVenue.visitors = visitorsOutput;
    return outputVenue;
}



@end
