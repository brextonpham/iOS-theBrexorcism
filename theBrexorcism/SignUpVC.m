//
//  SignUpVC.m
//  theBrexorcism
//
//  Created by Brexton Pham on 8/18/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "SignUpVC.h"
#import <Parse/Parse.h>

@interface SignUpVC ()

@end

@implementation SignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFQuery *query = [PFUser query]; //queries all users by default
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            self.allUsers = [[NSArray alloc] initWithArray:objects];
        }
    }];
}

- (IBAction)signupButton:(id)sender {
    //storing info from text fields
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //alerts user if nothing is inputted into fields
    if ([username length] == 0 || [password length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username, password, and email address!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        
        //creating new user in parse
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        
        NSUInteger rankInt = [self.allUsers count] + 1;
        NSNumber *rank = [NSNumber numberWithInteger:rankInt];
        newUser[@"rank"] = rank;
        newUser[@"wins"] = [NSNumber numberWithInteger:1];
        newUser[@"losses"] = [NSNumber numberWithInteger:0];
        newUser[@"ratio"] = [NSNumber numberWithInteger:0];
        
        //signing up and saving the user in parse background
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            //handles case where save fails
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else { //if save succeeds, navigate back to home screen
                [self.navigationController popToRootViewControllerAnimated:YES]; //goes straight back to root controller (home screen)
            }
        }];
    }
}

- (IBAction)dismissButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
