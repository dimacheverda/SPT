//
//  SPTInfoViewController.m
//  SPT
//
//  Created by Dima on 2/15/14.
//  Copyright (c) 2014 Dima. All rights reserved.
//

#import "SPTInfoViewController.h"
#import "SPTTextField.h"

@interface SPTInfoViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet SPTTextField *firstnameTextField;
@property (weak, nonatomic) IBOutlet SPTTextField *surnameTextField;
@property (weak, nonatomic) IBOutlet SPTTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation SPTInfoViewController

#pragma mark - View Controller

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.firstnameTextField.delegate = self;
    self.surnameTextField.delegate = self;
    self.emailTextField.delegate = self;
    [self.startButton.layer setCornerRadius:self.startButton.frame.size.height/2];
    
    // setup Tap Gesture for keyboard dismissal
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)hideKeyboard
{
    [self.firstnameTextField resignFirstResponder];
    [self.surnameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - IBAction

- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// dismiss keyboard when Return pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.firstnameTextField) {
        if ([self.surnameTextField canBecomeFirstResponder]) {
            [self.surnameTextField becomeFirstResponder];
        }
    } else {
//        [textField resignFirstResponder];
        if (textField == self.surnameTextField) {
            if ([self.emailTextField canBecomeFirstResponder]) {
                [self.emailTextField becomeFirstResponder];
            }
        } else {
            [textField resignFirstResponder];
        }
        
    }
    return YES;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
//    NSLog(@"should perform segue");
    if ([self.firstnameTextField.text isEqualToString:@""]
        || [self.surnameTextField.text isEqualToString:@""]
        || [self.emailTextField.text isEqualToString:@""]) {

        if ([self.firstnameTextField.text isEqualToString:@""]) {
            [self.firstnameTextField setBackgroundToError];
        }
        
        if ([self.surnameTextField.text isEqualToString:@""]) {
            [self.surnameTextField setBackgroundToError];
        }
        
        if ([self.emailTextField.text isEqualToString:@""]) {
            [self.emailTextField setBackgroundToError];
        }
        [self showAlertViewWithText:@"You have to fill all the fields"];
        
        return NO;
        
    } else {
        if (![self NSStringIsValidEmail:self.emailTextField.text]) {
            [self showAlertViewWithText:@"Email is not valid"];
            [self.emailTextField setBackgroundToError];
            
            return NO;
        }
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.firstnameTextField.text forKey:@"SPT_USER_FIRSTNAME"];
    [defaults setObject:self.surnameTextField.text forKey:@"SPT_USER_SURNAME"];
    [defaults setObject:self.emailTextField.text forKey:@"SPT_USER_EMAIL"];
    [defaults synchronize];
    
    return YES;
}

- (void)showAlertViewWithText:(NSString *)text
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:text
                                                       delegate:nil
                                              cancelButtonTitle:@"Back"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
