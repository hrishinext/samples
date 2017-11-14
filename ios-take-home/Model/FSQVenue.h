//
//  FSQVenue.h
//  ios-interview
//
//  Created by Hrishi Amravatkar on 11/13/17.
//  Copyright © 2017 Foursquare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSQVisitor.h"

@interface FSQVenue : NSObject

@property(nonatomic, readwrite) NSString *venueId;
@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) int openTime;
@property(nonatomic, readwrite) int closeTime;
@property(nonatomic, readwrite) NSArray<FSQVisitor *> *visitors;

@end
