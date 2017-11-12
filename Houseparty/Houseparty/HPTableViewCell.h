//
//  HPCellTableViewCell.h
//  Houseparty
//
//  Created by Hrishi  on 11/11/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPTableViewCell : UITableViewCell {
    
}
@property(nonatomic, weak) IBOutlet UILabel *fromId;
@property(nonatomic, weak) IBOutlet UILabel *fromName;
@property(nonatomic, weak) IBOutlet UILabel *toId;
@property(nonatomic, weak) IBOutlet UILabel *toName;
@property(nonatomic, weak) IBOutlet UILabel *areFriends;
@property(nonatomic, weak) IBOutlet UILabel *timestamp;

@end

