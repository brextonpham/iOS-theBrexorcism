//
//  meVC.m
//  theBrexorcism
//
//  Created by Brexton Pham on 8/24/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "meVC.h"
#import "challengeBrexceptVC.h"

@interface meVC ()

@end

@implementation meVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@ on meVC", currentUser.username);
    self.currentUserNameLabel.text = currentUser.username;
    
    PFQuery *winsQuery = [PFQuery queryWithClassName:@"Bridge"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [winsQuery whereKey:@"username" equalTo:currentUser.username];
        [winsQuery orderByDescending:@"createdAt"];
        [winsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.currentUserBridgeArrayWins != nil) {
                    self.currentUserBridgeArrayWins = nil;
                }
                self.currentUserBridgeArrayWins = [[NSMutableArray alloc] initWithArray:objects];
                if ([self.currentUserBridgeArrayWins count] > 0 && [self.currentUserBridgeArrayWins[0] objectForKey:@"updatedWins"] > 0) {
                    NSLog(@"whats up 1");
                    NSNumber *number = [self.currentUserBridgeArrayWins[0] objectForKey:@"updatedWins"];
                    [currentUser setObject:number forKey:@"wins"];
                    [currentUser saveInBackground];
                    NSUInteger number2 = [number integerValue];
                    NSString *number3 = [NSString stringWithFormat:@"%@", @(number2)];
                    self.winsLabel.text = number3;
                } else {
                    NSNumber *wins = [currentUser objectForKey:@"wins"];
                    NSInteger winsInt = [wins longValue];
                    NSString *winsStr = [NSString stringWithFormat:@"%ld", (long)winsInt];
                    self.winsLabel.text = winsStr;
                }
            }
        }];
    }
    
    PFQuery *lossQuery = [PFQuery queryWithClassName:@"Bridge"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [lossQuery whereKey:@"username" equalTo:currentUser.username];
        [lossQuery orderByDescending:@"createdAt"];
        [lossQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.currentUserBridgeArrayLosses != nil) {
                    self.currentUserBridgeArrayLosses = nil;
                }
                self.currentUserBridgeArrayLosses = [[NSMutableArray alloc] initWithArray:objects];
                if ([self.currentUserBridgeArrayLosses count] > 0 && [self.currentUserBridgeArrayLosses[0] objectForKey:@"updatedLosses"] > 0) {
                    NSLog(@"whats up FUCKER");
                    NSNumber *number = [self.currentUserBridgeArrayLosses[0] objectForKey:@"updatedLosses"];
                    [currentUser setObject:number forKey:@"losses"];
                    [currentUser saveInBackground];
                    NSUInteger number2 = [number integerValue];
                    NSString *number3 = [NSString stringWithFormat:@"%@", @(number2)];
                    self.lossesLabel.text = number3;
                    NSLog(@"number 3 %@", number3);
                } else {
                    NSLog(@"HI");
                    NSNumber *losses = [currentUser objectForKey:@"losses"];
                    NSInteger lossesInt = [losses longValue];
                    NSString *lossesStr = [NSString stringWithFormat:@"%ld", (long)lossesInt];
                    self.lossesLabel.text = lossesStr;
                    NSLog(@" SECOND number 3 %@", lossesStr);
                }
            }
        }];
    }
    
    NSNumber *ratio = [currentUser objectForKey:@"ratio"];
    float ratioFloat = [ratio floatValue];
    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
    self.ratioLabel.text = ratioStr;
    
    NSNumber *rankNumber = [currentUser objectForKey:@"rank"];
    NSUInteger rankInt = [rankNumber integerValue];
    NSString *rank = [NSString stringWithFormat:@"%@",  @(rankInt)];
    NSString *poundSign = @"#";
    NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, rank];
    
    self.rankLabel.text = rankString;
    
    [self checkForExistingChallenge];
    
    


    NSLog(@"FUCKING SHIT. %@", self.otherUser.username);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@ on meVC", currentUser.username);
    self.currentUserNameLabel.text = currentUser.username;
    
    PFQuery *winsQuery = [PFQuery queryWithClassName:@"Bridge"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [winsQuery whereKey:@"username" equalTo:currentUser.username];
        [winsQuery orderByDescending:@"createdAt"];
        [winsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.currentUserBridgeArrayWins != nil) {
                    self.currentUserBridgeArrayWins = nil;
                }
                self.currentUserBridgeArrayWins = [[NSMutableArray alloc] initWithArray:objects];
                if ([self.currentUserBridgeArrayWins count] > 0 && [self.currentUserBridgeArrayWins[0] objectForKey:@"updatedWins"] > 0) {
                    NSLog(@"whats up 1");
                    NSNumber *number = [self.currentUserBridgeArrayWins[0] objectForKey:@"updatedWins"];
                    [currentUser setObject:number forKey:@"wins"];
                    [currentUser saveInBackground];
                    NSUInteger number2 = [number integerValue];
                    NSString *number3 = [NSString stringWithFormat:@"%@", @(number2)];
                    self.winsLabel.text = number3;
                } else {
                    NSNumber *wins = [currentUser objectForKey:@"wins"];
                    NSInteger winsInt = [wins longValue];
                    NSString *winsStr = [NSString stringWithFormat:@"%ld", (long)winsInt];
                    self.winsLabel.text = winsStr;
                }
            }
        }];
    }

    
    PFQuery *lossQuery = [PFQuery queryWithClassName:@"Bridge"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [lossQuery whereKey:@"username" equalTo:currentUser.username];
        [lossQuery orderByDescending:@"createdAt"];
        [lossQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.currentUserBridgeArrayLosses != nil) {
                    self.currentUserBridgeArrayLosses = nil;
                }
                self.currentUserBridgeArrayLosses = [[NSMutableArray alloc] initWithArray:objects];
                if ([self.currentUserBridgeArrayLosses count] > 0 && [self.currentUserBridgeArrayLosses[0] objectForKey:@"updatedLosses"] > 0 ) {
                    NSLog(@"whats up");
                    NSNumber *number = [self.currentUserBridgeArrayLosses[0] objectForKey:@"updatedLosses"];
                    [currentUser setObject:number forKey:@"losses"];
                    [currentUser saveInBackground];
                    NSUInteger number2 = [number integerValue];
                    NSString *number3 = [NSString stringWithFormat:@"%@", @(number2)];
                    self.lossesLabel.text = number3;
                } else {
                    NSNumber *losses = [currentUser objectForKey:@"losses"];
                    NSInteger lossesInt = [losses longValue];
                    NSString *lossesStr = [NSString stringWithFormat:@"%ld", (long)lossesInt];
                    self.lossesLabel.text = lossesStr;
                }
            }
        }];
    }

    
    NSNumber *ratio = [currentUser objectForKey:@"ratio"];
    float ratioFloat = [ratio floatValue];
    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
    self.ratioLabel.text = ratioStr;
    
    NSNumber *rankNumber = [currentUser objectForKey:@"rank"];
    NSUInteger rankInt = [rankNumber integerValue];
    NSString *rank = [NSString stringWithFormat:@"%@",  @(rankInt)];
    NSString *poundSign = @"#";
    NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, rank];
    
    self.rankLabel.text = rankString;
    
    [self checkForExistingChallenge];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBrexcept"]) {
        NSLog(@"what part 2 %@", [self.currentChallenge objectForKey:@"objectId"]);
        challengeBrexceptVC *challengeBrexceptViewController = segue.destinationViewController;
        challengeBrexceptViewController.currentChallenge = self.currentChallenge;
        challengeBrexceptViewController.notYetChallenge = self.notYetChallenge;
    }
}

#pragma mark - good ol' helpers

- (void)checkForExistingChallenge {
    self.challenges = nil;
    PFQuery *query = [PFQuery queryWithClassName:@"Challenges"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [query orderByDescending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.challenges != nil) {
                    self.challenges = nil;
                }
                self.challenges = [[NSMutableArray alloc] init];
                for (int i = 0; i < [objects count]; i++) {
                    if ([[objects[i] objectForKey:@"challengee"] isEqualToString:[PFUser currentUser].username] && [[objects[i] objectForKey:@"Accepted"] isEqualToString:@"No"]) {
                        self.notYetChallenge = objects[i];
                        [self.challenges addObject:objects[i]];
                    }
                    NSLog(@"objectForKeyAccepted isEqualToString: %@", [objects[i] objectForKey:@"Accepted"]);
                    NSLog(@"objectForKeyChallengee isEqualToString: %@", [objects[i] objectForKey:@"challengee"]);
                    NSLog(@"currentUserUsername: %@", [PFUser currentUser].username);
                    if (([[objects[i] objectForKey:@"Accepted"] isEqualToString:@"Yes"] && [[objects[i] objectForKey:@"challengee"] isEqualToString:[PFUser currentUser].username]) || ([[objects[i] objectForKey:@"Accepted"] isEqualToString:@"Yes"] && [[objects[i] objectForKey:@"challenger"] isEqualToString:[PFUser currentUser].username])) {
                        NSLog(@"what what");
                        self.currentChallenge = objects[i];
                        [[PFUser currentUser] setObject:@"Yes" forKey:@"current"];
                    }
                }
                NSLog(@"Number of items in my second array is %d", [self.challenges count]);
            }
            int challengesCount = [self.challenges count];
            NSLog(@"Number of items in my second array (part 2) is %d", challengesCount);
            if (challengesCount > 0) {
                self.existingChallenge = YES;
            } else if (challengesCount == 0) {
                self.existingChallenge = NO;
            }
            if (self.existingChallenge) {
                [self performSegueWithIdentifier:@"showBrexcept" sender:self];
            }
            
            
            if (self.currentChallenge == nil) {
                self.currentChallengeNameLabel.text = @"N/A";
            } else {
                NSString *challengeeName = [self.currentChallenge objectForKey:@"challengee"];
                NSString *challengerName = [self.currentChallenge objectForKey:@"challenger"];
                if ([challengerName isEqualToString:[PFUser currentUser].username]) {
                    self.currentChallengeNameLabel.text = challengeeName;
                    PFQuery *query = [PFUser query];
                    [query whereKey:@"username" equalTo:challengeeName];
                    self.otherUser = (PFUser *)[query getFirstObject];
                } else {
                    self.currentChallengeNameLabel.text = challengerName;
                    PFQuery *query = [PFUser query];
                    [query whereKey:@"username" equalTo:challengerName];
                    self.otherUser = (PFUser *)[query getFirstObject];
                    NSLog(@"HI BREXTON %@", self.otherUser.username);
                }
            }
        }];
    }
    //query isn't fast enough. fix this in challenge class too.
}


- (IBAction)winButton:(id)sender {
    if (![self.currentChallengeNameLabel.text isEqualToString:@"N/A"]) {
        //PFUser *challengedUser = [self.currentChallenge objectForKey:@"challengee"];
        
        //done with wins
        self.currentChallengeNameLabel.text = @"N/A";
        PFUser *currentUser = [PFUser currentUser];
        NSNumber *currentUserWins = [currentUser objectForKey:@"wins"];
        NSUInteger currentUserWinsInt = [currentUserWins integerValue] + 1;
        NSString *currentUserWinsIntStr = [NSString stringWithFormat:@"%@", @(currentUserWinsInt)];
        self.winsLabel.text = currentUserWinsIntStr;
        
        currentUserWins = [NSNumber numberWithInteger:currentUserWinsInt];
        [currentUser setObject:currentUserWins forKey:@"wins"];
        [currentUser saveInBackground];
        
        
        //LOSIN.
        NSNumber *otherUserLosses = [self.otherUser objectForKey:@"losses"];
        NSUInteger *otherUserLossesInt = [otherUserLosses integerValue] + 1;
        otherUserLosses = [NSNumber numberWithInteger:otherUserLossesInt];
        
        NSString *message = @"finished challenge";
        NSData *fileData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSString *fileName = @"finishedChallenge";
        NSString *fileType = @"string";
        
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Can't bridge at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                PFObject *message = [PFObject objectWithClassName:@"Bridge"];
                [message setObject:file forKey:@"file"]; //Creating classes to save message to in parse
                [message setObject:fileType forKey:@"fileType"];
                [message setObject:[self.otherUser objectId] forKey:@"userObjectId"];
                [message setObject:self.otherUser.username forKey:@"username"];
                [message setObject:otherUserLosses forKey:@"updatedLosses"];
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

        
        
        //[self.currentChallenge deleteInBackground];
    }
}

- (IBAction)loseButton:(id)sender {
    if (![self.currentChallengeNameLabel.text isEqualToString:@"N/A"]) {
        //PFUser *challengedUser = [self.currentChallenge objectForKey:@"challengee"];
        
        //done with losses
        self.currentChallengeNameLabel.text = @"N/A";
        PFUser *currentUser = [PFUser currentUser];
        NSNumber *currentUserLosses = [currentUser objectForKey:@"losses"];
        NSUInteger currentUserLossesInt = [currentUserLosses integerValue] + 1;
        NSString *currentUserLossesIntStr = [NSString stringWithFormat:@"%@", @(currentUserLossesInt)];
        self.lossesLabel.text = currentUserLossesIntStr;
        
        currentUserLosses = [NSNumber numberWithInteger:currentUserLossesInt];
        [currentUser setObject:currentUserLosses forKey:@"losses"];
        [currentUser saveInBackground];
        
        
        //WINNIN.
        NSNumber *otherUserWins = [self.otherUser objectForKey:@"wins"];
        NSUInteger *otherUserWinsInt = [otherUserWins integerValue] + 1;
        otherUserWins = [NSNumber numberWithInteger:otherUserWinsInt];
        
        NSString *message = @"finished challenge";
        NSData *fileData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSString *fileName = @"finishedChallenge";
        NSString *fileType = @"string";
        
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Can't bridge at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                PFObject *message = [PFObject objectWithClassName:@"Bridge"];
                [message setObject:file forKey:@"file"]; //Creating classes to save message to in parse
                [message setObject:fileType forKey:@"fileType"];
                [message setObject:[self.otherUser objectId] forKey:@"userObjectId"];
                [message setObject:self.otherUser.username forKey:@"username"];
                [message setObject:otherUserWins forKey:@"updatedWins"];
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
        
        
        
        //[self.currentChallenge deleteInBackground];
    }
}
@end
