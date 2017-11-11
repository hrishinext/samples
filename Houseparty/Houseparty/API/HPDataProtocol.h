//
//  HPDataProcol.h
//  Houseparty
//
//  Created by Hrishi  on 11/11/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HPData.h"

@protocol HPDataProtocol <NSObject>

@required
- (void) fetchNewData:(NSArray <HPData *>*) data;

@end
