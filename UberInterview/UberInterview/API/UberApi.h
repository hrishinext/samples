//
//  UberApi.h
//  UberInterview
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UberVenue.h"

@interface UberApi : NSObject

-(void)searchVenues:(NSString *)query successBlock:(void (^)(NSArray<UberVenue *> *))success withFailure:(void(^)(NSError *))failure;

@end
