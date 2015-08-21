//
//  challengeVC.h
//  theBrexorcism
//
//  Created by Brexton Pham on 8/21/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface challengeVC : UIViewController

@property (strong, nonatomic) PFUser *challengedUser;
@property (strong, nonatomic) PFUser *currentUser;

- (IBAction)noButton:(id)sender;
- (IBAction)yesButton:(id)sender;

@end
