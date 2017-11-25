//
//  NSArray+sort.m
//  UberInterview
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import "NSArray+sort.h"
#import "UberVenue.h"

@implementation NSArray (sort)

-(NSMutableArray <UberVenue *> *) getSortedArray {
    
    NSSet *set = [[NSSet alloc] init];
    [set se]
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey: @"distance" ascending: YES];
    NSArray *sortedArray = [self sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    P[
    return [sortedArray mutableCopy];
    [sortedArray sor]
}

@end
