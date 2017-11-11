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
@property (nonatomic,strong) NSURLSessionDataTask *finderTask;
@end

@implementation HPAPI

-(void)loadHPData:(NSString *)timestamp successBlock:(void (^)(NSArray <HPData *>*))success withFailure:(void(^)(NSError *))failure {
    /*NSInputStream *inputStream = [NSString stringWithContentsOfURL:BASE_URI]; //An inputStream i got from http request
    uint8_t buffer[1024];
    int len;
    NSMutableString *total = [[NSMutableString alloc] init];
    while ([inputStream hasBytesAvailable]) {
        len = [inputStream read:buffer maxLength:sizeof(buffer)];
        if (len > 0) {
            [total appendString: [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding]];
        }
    }
    
    HPData *hpData = [[HPData alloc] init];
    success(hpData);*/

    /*NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URI, [NSString stringWithFormat:@"%@", timestamp]];
    NSLog(@"URL %@", urlString);
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil) {
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
        } else {
            failure(error);
        }
    }] resume];*/
    
    self.session = [self createSession];
    
    NSURL *dataURL = [NSURL URLWithString:BASE_URI];
    NSURLRequest *request = [NSURLRequest requestWithURL:dataURL];
    self.finderTask = [self.session dataTaskWithRequest:request];
    [self.finderTask resume];
    
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
    NSLog(@"new oo %@", brokenByLines);
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
