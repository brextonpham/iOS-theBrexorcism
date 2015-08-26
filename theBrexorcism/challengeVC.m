//
//  challengeVC.m
//  theBrexorcism
//
//  Created by Brexton Pham on 8/21/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "challengeVC.h"
#import <Parse/Parse.h>

@interface challengeVC ()

@end

@implementation challengeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self checkForExistingChallenge];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    [self checkForExistingChallenge];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)noButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)yesButton:(id)sender {
    if (self.existingChallenge == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Can't Challenge!" message:@"This person already has an existing challenge!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    } else {
        NSString *message = @"CHALLENGE!";
        NSData *fileData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSString *fileName = @"challenge";
        NSString *fileType = @"string";
        
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Can't send challenge at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                PFObject *message = [PFObject objectWithClassName:@"Challenges"];
                [message setObject:file forKey:@"file"]; //Creating classes to save message to in parse
                [message setObject:fileType forKey:@"fileType"];
                [message setObject:self.challengedUser forKey:@"recipientIds"];
                [message setObject:self.challengedUser.username forKey:@"challengee"];
                [message setObject:self.currentUser.username forKey:@"challenger"];
                [message setObject:@"No" forKey:@"Accepted"];
                [message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
                [message setObject:[[PFUser currentUser] username] forKey:@"senderName"];
                [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    } else {
                        //IT WORKED.
                    }
                }];
            }
        }];
        NSLog(@"this is the current user: %@", self.currentUser.username);
        NSLog(@"this is the challenged user: %@", self.challengedUser.username);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)checkForExistingChallenge {
    self.challenges = nil;
    PFQuery *query = [PFQuery queryWithClassName:@"Challenges"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        NSLog(@" CHECKING %@",[PFUser currentUser].username);
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.challenges != nil) {
                    self.challenges = nil;
                }
                self.challenges = [[NSMutableArray alloc] init];
                NSLog(@"challengedUser.username: %@", self.challengedUser.username);
                for (int i = 0; i < [objects count]; i++) {
                    if ([[objects[i] objectForKey:@"challengee"] isEqualToString:self.challengedUser.username]) {
                        [self.challenges addObject:objects[i]];
                    }
                }
                NSLog(@"Number of items in my second array is %d", [self.challenges count]);
            }
            int challengesCount = [self.challenges count];
            NSLog(@"Number of items in my second array (part 2) is %d", challengesCount);
            if (challengesCount > 0) {
                self.existingChallenge = YES;
            } else if (challengesCount == 0){
                self.existingChallenge = NO;
            }
        }];
    }
}

@end
