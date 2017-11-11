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

@interface HPAPI ()
@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic) double currentTimestamp;
@end

@implementation HPAPI

-(void)loadHPData:(NSString *)timestamp successBlock:(void (^)(NSArray <HPData *>*))success withFailure:(void(^)(NSError *))failure {
    self.session = [self createSession];
    if (_currentTimestamp == 0) {
        long currentTime = (long)(NSTimeInterval)([[NSDate date] timeIntervalSince1970]);
        _currentTimestamp = currentTime;
    }
    NSNumber *doubleNumber = [NSNumber numberWithDouble:_currentTimestamp];
    NSString *currentTimestampString = [doubleNumber stringValue];
    NSURL *dataURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URI, currentTimestampString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:dataURL];
    NSURLSessionDataTask *finderTask = [self.session dataTaskWithRequest:request];
    [finderTask resume];
}

#pragma mark Find Using NSURLSession Delegate Approach
- (NSURLSession *)createSession
{
    static NSURLSession *session = nil;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                            delegate:self
                                       delegateQueue:[NSOperationQueue mainQueue]];
    return session;
}

//The below method used the delegate approach to get data from the same web service

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data{
    NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *brokenByLines=[newStr componentsSeparatedByString:@"\n"];
    [self.delegate fetchNewData:[self buildHPDataListFromArray:brokenByLines]];
}

- (NSArray<HPData *>*) buildHPDataListFromArray:(NSArray *) inputArray {
    NSMutableArray<HPData *> *outputArray = [[NSMutableArray alloc] init];
    for (int i = (int)[inputArray count] - 1; i>=0; i--) {
        NSData *data = [inputArray[i] dataUsingEncoding:NSUTF8StringEncoding];
        id responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (responseDict != nil) {
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
            hpData.from = hpFrom;
            hpData.to = hpTo;
            hpData.areFriends = &(boolValue);
            NSString *timeString = [responseDict objectForKey:@"timestamp"];
            hpData.timestamp = [timeString doubleValue];
            [outputArray addObject:hpData];
        }
        if (i == 0) {
            NSString *lastTimestamp = [responseDict objectForKey:@"timestamp"];
            _currentTimestamp = [lastTimestamp longLongValue];
        }
    }
    return [outputArray copy];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler{
    NSLog(@"%s",__func__);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    NSLog(@"%s",__func__);
}


@end
