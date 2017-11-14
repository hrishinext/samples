//
//  FSQVisitor.h
//  ios-interview
//
//  Created by Hrishi Amravatkar on 11/13/17.
//  Copyright © 2017 Foursquare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSQVisitor : NSObject

@property(nonatomic, readwrite) NSString *visitorId;
@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) int arriveTime;
@property(nonatomic, readwrite) int leaveTime;

@end
