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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)noButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)yesButton:(id)sender {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
