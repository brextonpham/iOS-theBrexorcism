//
//  challengeBrexceptVC.h
//  theBrexorcism
//
//  Created by Brexton Pham on 8/25/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface challengeBrexceptVC : UIViewController

@property (strong, nonatomic) PFObject *currentChallenge;

- (IBAction)noButton:(id)sender;
- (IBAction)yesButton:(id)sender;

@end
