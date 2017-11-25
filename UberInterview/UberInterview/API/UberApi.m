//
//  UberApi.m
//  UberInterview
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import "UberApi.h"
#import "UberConstants.h"
#import "UberVenue.h"

@implementation UberApi

-(void)searchVenues:(NSString *)query successBlock:(void (^)(NSArray<UberVenue *> *))success withFailure:(void(^)(NSError *))failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@?ll=37.7749,-122.4194&%@&query=%@&%@&%@&%@", BASE_URI, RADIUS_KEY,[query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]],INTENT_KEY,OAUTH_KEY, V_KEY];
    NSLog(@"URL %@", urlString);
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            NSMutableArray <UberVenue *> *resultVenues = [[NSMutableArray alloc] init];
            
            //Iterate through bids and create array of order for bids
            NSDictionary *response = responseDict[@"response"];
            NSMutableArray *venuesData = response[@"venues"];
            for (int i = 0; i < [venuesData count]; i++) {
                UberVenue *uberVenue = [[UberVenue alloc] init];
                NSDictionary *venueDict = venuesData[i];
                uberVenue.name = venueDict[@"name"];
                uberVenue.address = venueDict[@"location"][@"address"];
                uberVenue.phoneNumber = venueDict[@"contact"][@"formattedPhone"];
                NSString *imageUrl;
                if (venueDict[@"categories"] != nil && venueDict[@"categories"][0] != nil) {
                    NSString *prefix = venueDict[@"categories"][0][@"icon"][@"prefix"];
                    NSString *suffix = venueDict[@"categories"][0][@"icon"][@"suffix"];
                    imageUrl = [NSString stringWithFormat:@"%@%@%@", prefix, IMAGE_SIZE, suffix];
                    uberVenue.imageUrlString = imageUrl;
                }
                uberVenue.distance = [venueDict[@"location"][@"distance"] integerValue];
                [resultVenues addObject:uberVenue];
            }
            success(resultVenues);
        } else {
            failure(error);
        }
    }] resume];
    
}

@end
