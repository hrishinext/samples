//
//  HPData.h
//  Houseparty
//
//  Created by Hrishi Amravatkar on 11/10/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPFrom.h"
#import "HPTo.h"

@interface HPData : NSObject

@property(nonatomic, readwrite) HPFrom *from;
@property(nonatomic, readwrite) HPTo *to;
@property(nonatomic, readwrite) BOOL areFriends;
@property(nonatomic, readwrite) double timestamp;


@end
