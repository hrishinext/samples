//
//  HPAPI.h
//  Houseparty
//
//  Created by Hrishi Amravatkar on 11/10/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPData.h"

@interface HPAPI : NSObject

-(void)loadHPData:(NSString *)timestamp successBlock:(void (^)(HPData *))success withFailure:(void(^)(NSError *))failure;

@end
