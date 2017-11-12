//
//  RegisterViewController.m
//  Papa Johns Voice Assistant
//
//  Created by Harrison Wainwright on 11/12/17.
//  Copyright © 2017 CS499. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerPressed:(id)sender {
    
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    NSString *repeatPassword = _repeatPasswordField.text;
    
    if([username length] == 0 || [password length] == 0 || [repeatPassword length] == 0)
    {
        return;
    }
    if(password != repeatPassword)
    {
        return;
    }
    
}

-(void)displayMessage:(NSString*)message{
    
    UIAlertController(title:@"Alert", message:message, prefferedStyle:UIAlertControllerStyle.Alert);
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
