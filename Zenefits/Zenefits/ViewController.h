//
//  ViewController.h
//  Zenefits
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, weak) IBOutlet UITextField *firstNameField;
@property(nonatomic, weak) IBOutlet UITextField *lastNameField;
@property(nonatomic, weak) IBOutlet UITextField *dobField;
@property(nonatomic, weak) IBOutlet UITextField *phoneNumberField;
@property(nonatomic, weak) IBOutlet UIButton *saveButton;

@end

