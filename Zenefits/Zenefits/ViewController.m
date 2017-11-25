//
//  ViewController.m
//  Zenefits
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSMutableDictionary *dataDict;
@property (nonatomic) BOOL isDisabled;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isDisabled = YES;
    self.dataDict = [[NSMutableDictionary alloc] init];
    [self.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.firstNameField.delegate = self;
    self.firstNameField.tag = 1;
    self.lastNameField.delegate = self;
    self.lastNameField.tag = 2;
    self.dobField.delegate = self;
    self.dobField.tag = 3;
    self.phoneNumberField.delegate = self;
    self.phoneNumberField.tag = 4;
    self.saveButton.enabled = NO;
}

- (void) save {

    NSLog(@"%@ %@ %@ %@", self.firstNameField.text, self.lastNameField.text, self.dobField.text, self.phoneNumberField.text);
    //set dictionary here
    if (self.firstNameField.text) {
        [self.dataDict setObject:self.firstNameField.text forKey:@"firstName"];
    }
    if (self.lastNameField.text) {
        [self.dataDict setObject:self.lastNameField.text forKey:@"lastName"];
    }
    if (self.dobField.text) {
        [self.dataDict setObject:self.dobField.text forKey:@"dob"];
    }
    if ([self isValidPhoneNumber:self.phoneNumberField.text]) {
        [self.dataDict setObject:self.phoneNumberField.text forKey:@"phoneNumber"];
    }
    [self serializeToJson];
};

- (BOOL) isValidPhoneNumber:(NSString *)phoneNumber {
    if ([phoneNumber length] == 10) {
        return YES;
    } else {
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1 && [textField.text length] > 0) {
        self.isDisabled = NO;
    }
    if (!self.isDisabled) {
        self.saveButton.enabled = YES;
    }
    
}

- (void)serializeToJson {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.dataDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
    } else {
        NSLog(@"%@", jsonData);
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
       // return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
