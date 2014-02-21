//
//  SPTAboutViewController.m
//  SPT
//
//  Created by Dima on 2/19/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import "SPTAboutViewController.h"

@interface SPTAboutViewController ()

@end

@implementation SPTAboutViewController

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - IBAction

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
