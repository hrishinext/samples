//
//  NSArray+hpFilters.h
//  Houseparty
//
//  Created by Hrishi Amravatkar on 11/11/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPData.h"

@interface NSArray (hpFilters)

-(NSMutableArray <HPData *> *) getSortedArray;
-(NSMutableArray <HPData *> *) filterByAreFriendsTrue;

@end
