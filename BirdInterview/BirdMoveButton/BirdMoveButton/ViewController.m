//
//  ViewController.m
//  BirdMoveButton
//
//  Created by Hrishi Amravatkar on 7/6/18.
//  Copyright © 2018 Hrishi Amravatkar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //drag view
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    [self.actionView addGestureRecognizer:panGesture];
    //pinch zoom view
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchViewGesture:)];
    [self.actionView addGestureRecognizer:pinchGesture];
    //rorate view
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateViewGesture:)];
    [self.actionView addGestureRecognizer:rotateGesture];
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *) gesture {
    CGPoint currentTouchLocation = [gesture locationInView:self.view];
    self.actionView.center = currentTouchLocation;
}

-(void)pinchViewGesture:(UIPinchGestureRecognizer *) gesture {
    self.actionView.transform = CGAffineTransformScale(self.actionView.transform, gesture.scale, gesture.scale);
    gesture.scale = 1.0;
}

-(void)rotateViewGesture:(UIRotationGestureRecognizer *) gesture {
    self.actionView.transform = CGAffineTransformRotate(self.actionView.transform, gesture.rotation);
    gesture.rotation = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
