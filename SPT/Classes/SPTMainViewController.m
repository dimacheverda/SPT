//
//  SPTMainViewController.m
//  SPT
//
//  Created by Dima on 2/13/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import "SPTMainViewController.h"

@interface SPTMainViewController ()

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;

@end

@implementation SPTMainViewController

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.startButton.layer setCornerRadius:self.startButton.frame.size.height/2];
    [self.aboutButton.layer setCornerRadius:self.aboutButton.frame.size.height/2];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
