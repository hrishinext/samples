//
//  HPAPI.h
//  Houseparty
//
//  Created by Hrishi Amravatkar on 11/10/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPData.h"
#import "HPDataProtocol.h"

@interface HPAPI : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property(nonatomic, weak) id<HPDataProtocol> delegate;

-(void)loadHPData;

@end
