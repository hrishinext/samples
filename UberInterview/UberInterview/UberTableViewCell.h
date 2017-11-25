//
//  UberTableViewCell.h
//  UberInterview
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UberTableViewCell : UITableViewCell

 UIImageView *venueImageView;
@property(nonatomic, weak) IBOutlet UILabel *venueName;
@property(nonatomic, weak) IBOutlet UILabel *veneueAddress;
@property(nonatomic, weak) IBOutlet UILabel *venuePhoneNo;
@property(nonatomic, weak) IBOutlet UILabel *venueDistance;

@end
