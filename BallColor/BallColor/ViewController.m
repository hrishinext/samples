//
//  ViewController.m
//  BallColor
//
//  Created by Hrishi Amravatkar on 11/20/17.
//  Copyright © 2017 Hrishi Amravatkar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic) NSMutableArray *randomBalls;
@property(nonatomic) NSMutableDictionary *ballColorDict;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //create randomBalls list
    self.randomBalls = [[NSMutableArray alloc] initWithObjects:@"red",@"blue", @"green", @"red", nil];
    self.ballColorDict = [[NSMutableDictionary alloc] init];
    NSString *resultBall = [self pickABall:self.randomBalls];
    NSLog(@"%@", resultBall);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)pickABall:(NSArray *)inputArray {
    int r = arc4random_uniform(100);
    NSLog(@"%d", r);
    //here create range list.
    //traverse through the list to get the percentage
    for (int i = 0; i < [inputArray count]; i++) {
        NSLog(@"current color %@", inputArray[i]);
        //create of range here based on color.
        //data structure
        if (![self.ballColorDict objectForKey:inputArray[i]]) {
            [self.ballColorDict setObject:@1 forKey:inputArray[i]];
        } else {
            NSNumber *currentCount = [self.ballColorDict objectForKey:inputArray[i]];
            currentCount = @([currentCount intValue] + 1);
            [self.ballColorDict setObject:currentCount forKey:inputArray[i]];
        }
    }
    NSLog(@"%@", self.ballColorDict);
    //now since you got the count create percentage or range
    //check in the dictionary
    float prevousPercetage = 0;
    for (NSString *currentKey in [self.ballColorDict allKeys]) {
        //create percentage of currentvalues
        NSNumber *currentCount = [self.ballColorDict objectForKey:currentKey];
        float percentage = (float)[currentCount intValue] / (float)[inputArray count] * 100 + prevousPercetage;
        prevousPercetage = percentage;
        NSLog(@"%lf" , percentage);
        if (r < percentage) {
            return currentKey;
        }
    }
    return NULL;
}


@end
