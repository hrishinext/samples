//
//  UberVenue.h
//  UberInterview
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberVenue : NSObject

@property(nonatomic, readwrite) NSString *name;
@property(nonatomic, readwrite) NSString *address;
@property(nonatomic, readwrite) NSString *phoneNumber;
@property(nonatomic, readwrite) NSString *imageUrlString;
@property(nonatomic, readwrite) NSInteger distance;

@end
