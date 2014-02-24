//
//  SPTPlaySessionViewController.m
//  SPT
//
//  Created by Dima on 2/14/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import "SPTPlaySessionViewController.h"
#import "SPTPlaySession.h"
#import "SPTQuestion.h"
#import "SPTResultViewController.h"
#import "UIButton+SPTAdditions.h"

@interface SPTPlaySessionViewController () <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *questionProgressView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerButton1;
@property (weak, nonatomic) IBOutlet UIButton *answerButton2;
@property (weak, nonatomic) IBOutlet UIButton *answerButton3;
@property (weak, nonatomic) IBOutlet UIButton *answerButton4;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIView *timerBackgroundView;

@property (strong, nonatomic) SPTPlaySession *playSession;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) NSInteger currentTime;
@property (strong, nonatomic) NSString *selectedAnswer;

@end

#define SESSION_DURATION 60*60

@implementation SPTPlaySessionViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.playSession = [[SPTPlaySession alloc] initWithQuestions];
    
    [self initTimer];
    
    [self setupViews];
    
    [self setupCurrentQuestion];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupViews];
    
    [self setupCurrentQuestion];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Views Setup

- (void)setupViews
{
    NSString *normalLight = @"button-normal-light";
//    NSString *normalDark = @"button-normal-dark";
//    NSString *filledlLight = @"button-filled-light";
    NSString *filledDark = @"button-filled-dark";
//    NSString *redLight = @"button-red-light";
//    NSString *redDark = @"button-red-dark";
//    NSString *greenDark = @"button-green-dark";
    NSString *pinkRed = @"button-pink-red";
    
    UIImage *buttonImage1 = [[UIImage imageNamed:filledDark] resizableImageWithCapInsets:UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0)];
//    UIImage *buttonImage2 = [[UIImage imageNamed:filledlLight] resizableImageWithCapInsets:UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0)];
    UIImage *buttonImage3 = [[UIImage imageNamed:normalLight] resizableImageWithCapInsets:UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0)];
//    UIImage *buttonImage4 = [[UIImage imageNamed:normalDark] resizableImageWithCapInsets:UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0)];
//    UIImage *buttonImage5 = [[UIImage imageNamed:redLight] resizableImageWithCapInsets:UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0)];
//    UIImage *buttonImage6 = [[UIImage imageNamed:redDark] resizableImageWithCapInsets:UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0)];
//    UIImage *buttonImage7 = [[UIImage imageNamed:greenDark] resizableImageWithCapInsets:UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0)];
    UIImage *buttonImage8 = [[UIImage imageNamed:pinkRed] resizableImageWithCapInsets:UIEdgeInsetsMake(22.0, 22.0, 22.0, 22.0)];
    
    [self.nextButton setBackgroundImage:buttonImage8 forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self.answerButton1 setBackgroundImage:buttonImage3 forState:UIControlStateNormal];
    [self.answerButton2 setBackgroundImage:buttonImage3 forState:UIControlStateNormal];
    [self.answerButton3 setBackgroundImage:buttonImage3 forState:UIControlStateNormal];
    [self.answerButton4 setBackgroundImage:buttonImage3 forState:UIControlStateNormal];
    
//    [self.answerButton1 setBackgroundImage:buttonImage1 forState:UIControlStateHighlighted];
//    [self.answerButton2 setBackgroundImage:buttonImage1 forState:UIControlStateHighlighted];
//    [self.answerButton3 setBackgroundImage:buttonImage1 forState:UIControlStateHighlighted];
//    [self.answerButton4 setBackgroundImage:buttonImage1 forState:UIControlStateHighlighted];
    
    [self.answerButton1 setBackgroundImage:buttonImage1 forState:UIControlStateSelected];
    [self.answerButton2 setBackgroundImage:buttonImage1 forState:UIControlStateSelected];
    [self.answerButton3 setBackgroundImage:buttonImage1 forState:UIControlStateSelected];
    [self.answerButton4 setBackgroundImage:buttonImage1 forState:UIControlStateSelected];
    
    [self.answerButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.answerButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.answerButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.answerButton4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
//    [self.answerButton1 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [self.answerButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [self.answerButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    [self.answerButton4 setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    [self.answerButton1 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.answerButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.answerButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.answerButton4 setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [self.timerBackgroundView.layer setCornerRadius:18.0];
}

- (void)setupCurrentQuestion
{
    SPTQuestion *currentQuestion = self.playSession.questions[self.playSession.currentQuestionIndex];
    
    self.questionLabel.text = [NSString stringWithFormat:@"%@", currentQuestion.problem];
    
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%d of 60", self.playSession.currentQuestionIndex + 1];
    
    [self.answerButton1 setTitle:currentQuestion.variants[0] forState:UIControlStateNormal];
    [self.answerButton2 setTitle:currentQuestion.variants[1] forState:UIControlStateNormal];
    [self.answerButton3 setTitle:currentQuestion.variants[2] forState:UIControlStateNormal];
    [self.answerButton4 setTitle:currentQuestion.variants[3] forState:UIControlStateNormal];
    
    [self.answerButton1 setTitle:currentQuestion.variants[0] forState:UIControlStateSelected];
    [self.answerButton2 setTitle:currentQuestion.variants[1] forState:UIControlStateSelected];
    [self.answerButton3 setTitle:currentQuestion.variants[2] forState:UIControlStateSelected];
    [self.answerButton4 setTitle:currentQuestion.variants[3] forState:UIControlStateSelected];
    
    CGRect progressViewFrame = self.questionProgressView.frame;
    CGFloat progresWidth = self.view.frame.size.width / self.playSession.questions.count * (self.playSession.currentQuestionIndex + 1);
    progressViewFrame.size.width = progresWidth;
    self.questionProgressView.frame = progressViewFrame;
}

#pragma mark - IBAction Methods

- (IBAction)backButtonPressed:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Exit"
                                                        message:@"You sure want to exit"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Yes", nil];
    alertView.delegate = self;
    [alertView show];
}

- (IBAction)infoButtonPressed:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:@"Choose the best word or phrase (a, b, c or d) to fill each blank."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
//    alertView.delegate = self;
    [alertView show];
}

- (IBAction)answerButtonPressed:(UIButton *)sender
{
    self.selectedAnswer = sender.titleLabel.text;
    
    if (sender != self.answerButton1) {[self.answerButton1 setSelected:NO];} else {[self.answerButton1 setSelected:YES];}
    if (sender != self.answerButton2) {[self.answerButton2 setSelected:NO];} else {[self.answerButton2 setSelected:YES];}
    if (sender != self.answerButton3) {[self.answerButton3 setSelected:NO];} else {[self.answerButton3 setSelected:YES];}
    if (sender != self.answerButton4) {[self.answerButton4 setSelected:NO];} else {[self.answerButton4 setSelected:YES];}
}

- (IBAction)nextButtonPressed:(UIButton *)sender
{
    [self checkAnswer:self.selectedAnswer];
    
    [self.answerButton1 setSelected:NO];
    [self.answerButton2 setSelected:NO];
    [self.answerButton3 setSelected:NO];
    [self.answerButton4 setSelected:NO];
    
    [self setupCurrentQuestion];
}

- (void)checkAnswer:(NSString *)answer
{
    if ([self.playSession checkQuestionWithAnswer:answer]) {
        self.playSession.score += 10;
    };
    
    if (self.playSession.currentQuestionIndex + 1 == self.playSession.questions.count) {
//        NSLog(@"Finish score : %d", self.playSession.score);
        [self performSegueWithIdentifier:@"Show Result" sender:self];
    } else {
        self.playSession.currentQuestionIndex++;
    }
}

#pragma mark - Timer

- (void)initTimer
{
    self.currentTime = 60*60;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                                selector:@selector(timerTick)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)timerTick
{
    if (self.currentTime != 0) {
        self.currentTime--;
        NSLog(@"%d", self.currentTime);
    }
    
    NSUInteger minutes, seconds;
    minutes = self.currentTime / 60;
    seconds = self.currentTime % 60;
    
    self.timerLabel.text = [NSString stringWithFormat:@"%2.2d:%2.2d", minutes, seconds];
    
    if (self.currentTime == 0) {
        [self stopTimer];
        [self timeExpired];
    }
}

- (void)stopTimer
{
    [self.timer invalidate];
}

- (void)timeExpired
{
    UIAlertView *timeExpiredAlertView = [[UIAlertView alloc] initWithTitle:@"Time Limit Exceeded"
                                                                   message:@"You have reached the time limit set for the quiz. Press 'OK' to continue"
                                                                  delegate:nil
                                                         cancelButtonTitle:nil
                                                         otherButtonTitles:@"OK", nil];
    timeExpiredAlertView.delegate = self;
    [timeExpiredAlertView show];
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Time Limit Exceeded"]) {
//        NSLog(@"time limit");
        [self performSegueWithIdentifier:@"Show Result" sender:self];
    }
    
    if ([alertView.title isEqualToString:@"Exit"] && buttonIndex == 1) {
//        NSLog(@"exit %d", buttonIndex);
        [[[self presentingViewController] presentingViewController]  dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Result"]) {
        SPTResultViewController *resultVC = [segue destinationViewController];
        [resultVC setScore:self.playSession.score];
        [self stopTimer];
    }
    
    if ([segue.identifier isEqualToString:@"Time Expired"]) {
//        NSLog(@"time expired");
    }
}

@end
