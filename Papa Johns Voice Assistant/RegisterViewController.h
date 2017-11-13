//
//  RegisterViewController.h
//  Papa Johns Voice Assistant
//
//  Created by Harrison Wainwright on 11/12/17.
//  Copyright © 2017 CS499. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPasswordField;

@end
