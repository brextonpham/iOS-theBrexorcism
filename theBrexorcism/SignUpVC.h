//
//  SignUpVC.h
//  theBrexorcism
//
//  Created by Brexton Pham on 8/18/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)signupButton:(id)sender;
- (IBAction)dismissButton:(id)sender;

@end
