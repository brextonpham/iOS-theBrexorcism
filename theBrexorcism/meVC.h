//
//  meVC.h
//  theBrexorcism
//
//  Created by Brexton Pham on 8/24/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface meVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *winsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lossesLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentChallengeNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *challenges;
@property BOOL existingChallenge;
@property (strong, nonatomic) PFObject *currentChallenge;
@property (strong, nonatomic) PFObject *acceptedChallenge;
@property (strong, nonatomic) PFObject *notYetChallenge;
@property (strong, nonatomic) PFUser *otherUser;
@property (strong, nonatomic) NSMutableArray *currentUserBridgeArrayLosses;
@property (strong, nonatomic) NSMutableArray *currentUserBridgeArrayWins;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *pastChallenges;

- (IBAction)winButton:(id)sender;
- (IBAction)loseButton:(id)sender;

@end
