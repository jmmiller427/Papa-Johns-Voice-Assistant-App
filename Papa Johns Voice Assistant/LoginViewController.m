//
//  LoginViewController.m
//  Papa Johns Voice Assistant
//
//  Created by Harrison Wainwright on 11/12/17.
//  Copyright © 2017 CS499. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameField;
@synthesize passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard
{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (IBAction)loginPressed:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *username = [defaults stringForKey:@"username"];
    NSString *password = [defaults stringForKey:@"password"];
    
    // User entered correct information
    if([usernameField.text isEqualToString:username] && [passwordField.text isEqualToString:password])
    {
        bool loggedIn = YES;
        [defaults setBool:loggedIn forKey:@"loggedIn"];
        [defaults synchronize];
        [self dismissViewControllerAnimated:YES completion: nil];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Username/Password entered is incorrect" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:(alert) animated:true completion:nil];
    }
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
