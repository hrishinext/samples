//
//  NSArray+hpFilters.m
//  Houseparty
//
//  Created by Hrishi Amravatkar on 11/11/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import "NSArray+hpFilters.h"

@implementation NSArray (hpFilters)

-(NSMutableArray <HPData *> *) getSortedArray {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey: @"timestamp" ascending: NO];
    NSArray *sortedArray = [self sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    return [sortedArray mutableCopy];
}

-(NSMutableArray <HPData *> *) filterByAreFriendsTrue {
    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"_areFriends == YES"];
    NSArray *filteredArray =
    [self filteredArrayUsingPredicate:newPredicate];
    return [filteredArray mutableCopy];
}
@end
