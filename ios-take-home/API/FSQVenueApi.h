//
//  FSQVenueApi.h
//  ios-interview
//
//  Created by Hrishi Amravatkar on 11/13/17.
//  Copyright © 2017 Foursquare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSQVenue.h"

@interface FSQVenueApi : NSObject

-(void)getVenueInfo:(void (^)(FSQVenue *))success withFailure:(void(^)(NSError *))failure;

@end
