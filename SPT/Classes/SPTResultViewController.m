//
//  SPTResultViewController.m
//  SPT
//
//  Created by Dima on 2/14/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import "SPTResultViewController.h"
#import "STKSpinnerView.h"
#import <MessageUI/MessageUI.h>
#import "UIColor+SPTAdditions.h"

@interface SPTResultViewController () <MFMailComposeViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet STKSpinnerView *spinnerView;
@property (weak, nonatomic) IBOutlet UILabel *congratLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendMailButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;

@property (strong, nonatomic) NSString *firstname;
@property (strong, nonatomic) NSString *surname;
//@property (strong, nonatomic) NSString *emailResult;
@property (nonatomic) BOOL emailSent;
@property (strong, nonatomic) UIImage *screenshot;
@end

#define MAX_SCORE 600.0

@implementation SPTResultViewController

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];

//    self.score = 500;
    
    self.spinnerView.color = [UIColor turquoiseColor];
    self.spinnerView.wellThickness = 15.0;
    [self.sendMailButton.layer setCornerRadius:self.sendMailButton.frame.size.height/2];
    [self.homeButton.layer setCornerRadius:self.homeButton.frame.size.height/2];
    
    [self loadUserCredentials];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setScoreText:self.score];
        [self.spinnerView setProgress:self.score / MAX_SCORE
                             animated:YES];

    });    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)loadUserCredentials
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.firstname = [defaults objectForKey:@"SPT_USER_FIRSTNAME"];
    self.surname = [defaults objectForKey:@"SPT_USER_SURNAME"];
    
    NSString *congratString = [NSString stringWithFormat:@"%@, %@", self.firstname, self.congratLabel.text];
    self.congratLabel.text = congratString;
}

- (void)setScoreText:(NSUInteger)score
{
    NSUInteger _currentScore = 0;
    
    for (int i = 0; i < score; i++) {
        _currentScore++;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.scoreLabel.text = [NSString stringWithFormat:@"%d", _currentScore];
                self.scoreLabel.textColor = [UIColor colorWithRed:(MAX_SCORE - _currentScore) / MAX_SCORE
                                                            green:161.0 / 255.0
                                                             blue:35.0 / 255.0
                                                            alpha:1.0];
                [NSThread sleepForTimeInterval:0.5 / score];
                NSLog(@"%d", _currentScore);
            }];
    }
}

#pragma mark - Mail

- (UIImage *)takeScreenshot
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)sendResultButtonPressed:(UIButton *)sender
{
    if (!self.screenshot) {
        self.screenshot = [self takeScreenshot];
    }
    if ([MFMailComposeViewController canSendMail]) {
        
        // Email Subject
        NSString *emailTitle = @"Result Email";
        
        // Email Content
        NSString *messageBody = [NSString stringWithFormat:@"I have passed Swan Placement Test.\nMy First Name : %@.\nMy Surname : %@.\nMy score : %d.", self.firstname, self.surname, self.score];
        
        // To address
        NSArray *toRecipents = [NSArray arrayWithObject:@"cheverda4@e-mail.ua"];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:NO];
        [mc setToRecipients:toRecipents];
        [mc addAttachmentData:UIImagePNGRepresentation(self.screenshot) mimeType:@"image/png" fileName:@"Screenshot"];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: {
            NSLog(@"Mail cancelled");
//            self.emailResult = @"Cancelled";
            break;
        }
        
        case MFMailComposeResultSaved: {
            NSLog(@"Mail saved");
//            self.emailResult = @"Saved";
            self.emailSent = YES;
            break;
        }
            
        case MFMailComposeResultSent: {
            NSLog(@"Mail sent");
//            self.emailResult = @"Sent";
            self.emailSent = YES;
            break;
        }
        
        case MFMailComposeResultFailed: {
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
//            self.emailResult = @"Failed";
            break;
        }
            
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Home

- (IBAction)homeButtomPressed:(UIButton *)sender
{
//    if (!self.emailResult || [self.emailResult isEqualToString:@"Cancelled"]) {
    if (!self.emailSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention"
                                                        message:@"You haven't submitted you test result. Are you sure you want to exit?"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Exit",nil];
        alert.delegate = self;
        [alert show];
    } else {
        [[[[self presentingViewController] presentingViewController] presentingViewController]  dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:@"Attention"] && buttonIndex == 1) {
        [[[[self presentingViewController] presentingViewController] presentingViewController]  dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
