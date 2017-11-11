//
//  HPAPI.m
//  Houseparty
//
//  Created by Hrishi Amravatkar on 11/10/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import "HPAPI.h"
#import "HPData.h"
#import "HPConstants.h"
#import "Communicator.h"

@implementation HPAPI

-(void)loadHPData:(NSString *)timestamp successBlock:(void (^)(HPData *))success withFailure:(void(^)(NSError *))failure {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@", BASE_URI];
    NSLog(@"URL %@", urlString);
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error)
        {
            failure(error);
        }
        else
        {
            NSError *jsonError = nil;
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
            if (jsonError)
            {
                // Handle the error
            }
            else
            {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                HPData *hpData = [[HPData alloc] init];
                HPFrom *hpFrom = [[HPFrom alloc] init];
                NSDictionary *fromHP = [responseDict objectForKey:@"from"];
                hpFrom.fromId = [fromHP objectForKey:@"id"];
                hpFrom.name = [fromHP objectForKey:@"name"];
                
                HPTo *hpTo = [[HPTo alloc] init];
                NSDictionary *toHP = [responseDict objectForKey:@"to"];
                hpTo.toId  = [toHP objectForKey:@"id"];
                hpTo.name = [toHP objectForKey:@"name"];
                
                BOOL boolValue = [[responseDict objectForKey:@"areFriends"] boolValue];
                hpData.areFriends = &(boolValue);
                hpData.timestamp = [responseDict objectForKey:@"timestamp"];
                success(hpData);
            }
        }
    }];
    
    [dataTask resume];
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode) {
        case NSStreamEventEndEncountered:
        {
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop]
                              forMode:NSDefaultRunLoopMode];
            //[stream release];
            stream = nil; // stream is ivar, so reinit it
            break;
        }
        default: break;
            
    }
}

@end
