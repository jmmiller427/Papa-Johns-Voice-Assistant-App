//
//  RegisterViewController.m
//  Papa Johns Voice Assistant
//
//  Created by Harrison Wainwright on 11/12/17.
//  Copyright © 2017 CS499. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize repeatPasswordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Allow keyboard to be hidden on screen click
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    [repeatPasswordField resignFirstResponder];
}

// If there is an error display proper message
-(void)displayMessage:(NSString*)errorMessage{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:(alert) animated:true completion:nil];
}

// If register button is pressed perform action
- (IBAction)registerPressed:(id)sender {
    
    // Ensure all fields have been entered
    if([usernameField.text isEqualToString:@""] || [passwordField.text isEqualToString:@""] || [repeatPasswordField.text isEqualToString:@""])
    {
        [self displayMessage:@"All fields must be filled out"];
        return;
    }
    // Ensure both password fields match
    if(passwordField.text != repeatPasswordField.text)
    {
        [self displayMessage:@"Passwords do not match"];
        return;
    }
    // Ensure the password entered is of correct length
    if(passwordField.text.length < 8)
    {
        [self displayMessage:@"Password must be at least 8 characters"];
        return;
    }
    
    // Store user data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:usernameField.text forKey:@"username"];
    [defaults setObject:passwordField.text forKey:@"password"];
    [defaults synchronize];
    
    // Alert user of completion before leaving page
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Complete" message:@"User Registration Complete!" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {[self dismissViewControllerAnimated:YES completion: nil];}];
    
    [alert addAction:defaultAction];
    [self presentViewController:(alert) animated:true completion:nil];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
