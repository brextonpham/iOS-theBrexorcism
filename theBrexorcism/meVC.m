//
//  meVC.m
//  theBrexorcism
//
//  Created by Brexton Pham on 8/24/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "meVC.h"
#import "challengeBrexceptVC.h"
#import "myPastChallengesCell.h"

@interface meVC ()

@end

@implementation meVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bridgeFlag1 = NO;
    self.bridgeFlag2 = NO;
    
    //Make self the delegate and datasource of the tableview
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    //refresh screen!
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrievePastChallenges) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.tableView reloadData];
    
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
                    self.currentBridge = self.currentUserBridgeArrayWins[0];
                    NSNumber *number = [self.currentUserBridgeArrayWins[0] objectForKey:@"updatedWins"];
                    self.currentUserWins = [number floatValue];
                    [currentUser setObject:number forKey:@"wins"];
                    [currentUser saveInBackground];
                    NSUInteger number2 = [number integerValue];
                    NSString *number3 = [NSString stringWithFormat:@"%@", @(number2)];
                    self.winsLabel.text = number3;
                } else {
                    NSNumber *wins = [currentUser objectForKey:@"wins"];
                    self.currentUserWins = [wins floatValue];
                    NSInteger winsInt = [wins longValue];
                    NSString *winsStr = [NSString stringWithFormat:@"%ld", (long)winsInt];
                    self.winsLabel.text = winsStr;
                }
            }
            self.bridgeFlag1 = YES;
            NSLog(@" self.currentUserWins = %d", self.currentUserWins);
            if (self.bridgeFlag1 == YES && self.bridgeFlag2 == YES  && self.bridgeFlag3 == YES) {
                if (self.currentUserLosses != 0) {
                    float ratioFloat = self.currentUserWins/self.currentUserLosses;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                } else {
                    float ratioFloat = self.currentUserWins;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
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
                    self.currentBridge = self.currentUserBridgeArrayLosses[0];
                    NSNumber *number = [self.currentUserBridgeArrayLosses[0] objectForKey:@"updatedLosses"];
                    self.currentUserLosses = [number floatValue];
                    [currentUser setObject:number forKey:@"losses"];
                    [currentUser saveInBackground];
                    NSUInteger number2 = [number integerValue];
                    NSString *number3 = [NSString stringWithFormat:@"%@", @(number2)];
                    self.lossesLabel.text = number3;
                    NSLog(@"number 3 %@", number3);
                } else {
                    NSLog(@"HI");
                    NSNumber *losses = [currentUser objectForKey:@"losses"];
                    self.currentUserLosses = [losses floatValue];
                    NSInteger lossesInt = [losses longValue];
                    NSString *lossesStr = [NSString stringWithFormat:@"%ld", (long)lossesInt];
                    self.lossesLabel.text = lossesStr;
                    NSLog(@" SECOND number 3 %@", lossesStr);
                }
            }
            self.bridgeFlag2 = YES;
            if (self.bridgeFlag1 == YES && self.bridgeFlag2 == YES  && self.bridgeFlag3 == YES) {
                if (self.currentUserLosses != 0) {
                    CGFloat ratioFloat = self.currentUserWins/self.currentUserLosses;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                } else {
                    CGFloat ratioFloat = self.currentUserWins;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                }
            }
        }];
    }
    
    //watch out for bridge being deleted
    
    PFQuery *rankQuery1 = [PFQuery queryWithClassName:@"Bridge"];
    PFQuery *rankQuery2 = [PFQuery queryWithClassName:@"Bridge"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [rankQuery1 whereKey:@"username" equalTo:[PFUser currentUser].username];
        [rankQuery2 whereKey:@"thirdUser" equalTo:[PFUser currentUser].username];
        PFQuery *mainRankQuery = [PFQuery orQueryWithSubqueries:@[rankQuery1,rankQuery2]];
        [mainRankQuery orderByDescending:@"createdAt"];
        [mainRankQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.currentUserBridgeArrayRank != nil) {
                    self.currentUserBridgeArrayRank = nil;
                }
                self.currentUserBridgeArrayRank = [[NSMutableArray alloc] initWithArray:objects];
                if (([self.currentUserBridgeArrayRank count] > 0 && [self.currentUserBridgeArrayRank[0] objectForKey:@"updatedRankNumberForOtherUser"] > 0) || ([self.currentUserBridgeArrayRank count] > 0 && [self.currentUserBridgeArrayRank[0] objectForKey:@"thirdUserRankNumber"] > 0)) {
                    
                    self.currentBridge = self.currentUserBridgeArrayRank[0];
                    
                    NSLog(@"TELL ME WHO THE THIRD USER IS %@", [self.currentBridge objectForKey:@"thirdUser"]);
                    NSLog(@"TELL ME WHO THE CURRENT USER IS %@", currentUser.username);
                    NSLog(@"TELL ME WHO THE USERNAME USER IS %@", [self.currentBridge objectForKey:@"username"]);
                    
                    if ([[self.currentBridge objectForKey:@"thirdUser"] isEqualToString:currentUser.username]) {
                        NSNumber *newRank = [self.currentBridge objectForKey:@"thirdUserRankNumber"];
                        [currentUser setObject:newRank forKey:@"rank"];
                        [currentUser saveInBackground];
                        NSUInteger newRankInt = [newRank integerValue];
                        NSString *newRankStr = [NSString stringWithFormat:@"%@", @(newRankInt)];
                        NSString *poundSign = @"#";
                        NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, newRankStr];
                        self.rankLabel.text = rankString;
                        [self.currentBridge setObject:[NSNumber numberWithInt:0] forKey:@"thirdUserRankNumber"];
                        NSLog(@"made it part 1");
                        [self.currentBridge saveInBackground];
                        
                    } else if ([[self.currentBridge objectForKey:@"username"] isEqualToString:currentUser.username]) {
                        NSNumber *newRank = [self.currentBridge objectForKey:@"updatedRankNumberForOtherUser"];
                        [currentUser setObject:newRank forKey:@"rank"];
                        [currentUser saveInBackground];
                        NSUInteger newRankInt = [newRank integerValue];
                        NSString *newRankStr = [NSString stringWithFormat:@"%@", @(newRankInt)];
                        NSString *poundSign = @"#";
                        NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, newRankStr];
                        self.rankLabel.text = rankString;
                        [self.currentBridge setObject:[NSNumber numberWithInt:0] forKey:@"updatedRankNumberForOtherUser"];
                        NSLog(@"made it part 2");
                        [self.currentBridge saveInBackground];
                    }
                    
                } else {
                    NSNumber *rankNumber = [currentUser objectForKey:@"rank"];
                    NSUInteger rankInt = [rankNumber integerValue];
                    NSString *rank = [NSString stringWithFormat:@"%@",  @(rankInt)];
                    NSString *poundSign = @"#";
                    NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, rank];
                    self.rankLabel.text = rankString;
                }
            }
            self.bridgeFlag3 = YES;
            if (self.bridgeFlag1 == YES && self.bridgeFlag2 == YES && self.bridgeFlag3 == YES) {
                if (self.currentUserLosses != 0) {
                    CGFloat ratioFloat = self.currentUserWins/self.currentUserLosses;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                } else {
                    CGFloat ratioFloat = self.currentUserWins;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                }
            }
            if (self.bridgeFlag1 == YES && self.bridgeFlag2 == YES && self.bridgeFlag3 == YES && [self.currentBridge objectForKey:@"thirdUserRankNumber"] == [NSNumber numberWithInt:0] && [self.currentBridge objectForKey:@"updatedRankNumberForOtherUser"] == [NSNumber numberWithInt:0]) {
                [self.currentBridge deleteInBackground];
            }
        }];
    }
    
    NSNumber *currentUserRankNumber = [currentUser objectForKey:@"rank"];
    NSUInteger currentUserRankInt = [currentUserRankNumber integerValue];
    
    PFQuery *query = [PFUser query];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [query orderByAscending:@"rank"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                NSLog(@"what what what what what what what");
                if (self.ladder != nil) {
                    self.ladder= nil;
                }
                if (self.thirdUser != nil) {
                    self.thirdUser = nil;
                }
                self.ladder = [[NSMutableArray alloc] initWithArray:objects];
                self.thirdUser = self.ladder[currentUserRankInt - 2];
                NSLog(@"THIS IS THE THIRD USER %@", self.thirdUser.username);
            }
        }];
        
    }
    
    [self checkForExistingChallenge];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bridgeFlag1 = NO;
    self.bridgeFlag2 = NO;
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
                    self.currentBridge = self.currentUserBridgeArrayWins[0];
                    NSNumber *number = [self.currentUserBridgeArrayWins[0] objectForKey:@"updatedWins"];
                    self.currentUserWins = [number floatValue];
                    [currentUser setObject:number forKey:@"wins"];
                    [currentUser saveInBackground];
                    NSUInteger number2 = [number integerValue];
                    NSString *number3 = [NSString stringWithFormat:@"%@", @(number2)];
                    self.winsLabel.text = number3;
                } else {
                    NSNumber *wins = [currentUser objectForKey:@"wins"];
                    self.currentUserWins = [wins floatValue];
                    NSInteger winsInt = [wins longValue];
                    NSString *winsStr = [NSString stringWithFormat:@"%ld", (long)winsInt];
                    self.winsLabel.text = winsStr;
                }
            }
            self.bridgeFlag1 = YES;
            NSLog(@" self.currentUserWins = %d", self.currentUserWins);
            if (self.bridgeFlag1 == YES && self.bridgeFlag2 == YES  && self.bridgeFlag3 == YES) {
                if (self.currentUserLosses != 0) {
                    float ratioFloat = self.currentUserWins/self.currentUserLosses;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                } else {
                    float ratioFloat = self.currentUserWins;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
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
                    self.currentBridge = self.currentUserBridgeArrayLosses[0];
                    NSNumber *number = [self.currentUserBridgeArrayLosses[0] objectForKey:@"updatedLosses"];
                    self.currentUserLosses = [number floatValue];
                    [currentUser setObject:number forKey:@"losses"];
                    [currentUser saveInBackground];
                    NSUInteger number2 = [number integerValue];
                    NSString *number3 = [NSString stringWithFormat:@"%@", @(number2)];
                    self.lossesLabel.text = number3;
                    NSLog(@"number 3 %@", number3);
                } else {
                    NSLog(@"HI");
                    NSNumber *losses = [currentUser objectForKey:@"losses"];
                    self.currentUserLosses = [losses floatValue];
                    NSInteger lossesInt = [losses longValue];
                    NSString *lossesStr = [NSString stringWithFormat:@"%ld", (long)lossesInt];
                    self.lossesLabel.text = lossesStr;
                    NSLog(@" SECOND number 3 %@", lossesStr);
                }
            }
            self.bridgeFlag2 = YES;
            if (self.bridgeFlag1 == YES && self.bridgeFlag2 == YES  && self.bridgeFlag3 == YES) {
                if (self.currentUserLosses != 0) {
                    CGFloat ratioFloat = self.currentUserWins/self.currentUserLosses;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                } else {
                    CGFloat ratioFloat = self.currentUserWins;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                }
            }
        }];
    }
    
    //watch out for bridge being deleted
    
    PFQuery *rankQuery1 = [PFQuery queryWithClassName:@"Bridge"];
    PFQuery *rankQuery2 = [PFQuery queryWithClassName:@"Bridge"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [rankQuery1 whereKey:@"username" equalTo:[PFUser currentUser].username];
        [rankQuery2 whereKey:@"thirdUser" equalTo:[PFUser currentUser].username];
        PFQuery *mainRankQuery = [PFQuery orQueryWithSubqueries:@[rankQuery1,rankQuery2]];
        [mainRankQuery orderByDescending:@"createdAt"];
        [mainRankQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.currentUserBridgeArrayRank != nil) {
                    self.currentUserBridgeArrayRank = nil;
                }
                self.currentUserBridgeArrayRank = [[NSMutableArray alloc] initWithArray:objects];
                if (([self.currentUserBridgeArrayRank count] > 0 && [self.currentUserBridgeArrayRank[0] objectForKey:@"updatedRankNumberForOtherUser"] > 0) || ([self.currentUserBridgeArrayRank count] > 0 && [self.currentUserBridgeArrayRank[0] objectForKey:@"thirdUserRankNumber"] > 0)) {
                    
                    self.currentBridge = self.currentUserBridgeArrayRank[0];
                    
                    if ([[self.currentBridge objectForKey:@"thirdUser"] isEqualToString:currentUser.username]) {
                        NSNumber *newRank = [self.currentBridge objectForKey:@"thirdUserRankNumber"];
                        [currentUser setObject:newRank forKey:@"rank"];
                        [currentUser saveInBackground];
                        NSUInteger newRankInt = [newRank integerValue];
                        NSString *newRankStr = [NSString stringWithFormat:@"%@", @(newRankInt)];
                        NSString *poundSign = @"#";
                        NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, newRankStr];
                        self.rankLabel.text = rankString;
                        [self.currentBridge setObject:[NSNumber numberWithInt:0] forKey:@"thirdUserRankNumber"];
                        [self.currentBridge saveInBackground];
                        
                    } else if ([[self.currentBridge objectForKey:@"username"] isEqualToString:currentUser.username]) {
                        NSNumber *newRank = [self.currentBridge objectForKey:@"updatedRankNumberForOtherUser"];
                        [currentUser setObject:newRank forKey:@"rank"];
                        [currentUser saveInBackground];
                        NSUInteger newRankInt = [newRank integerValue];
                        NSString *newRankStr = [NSString stringWithFormat:@"%@", @(newRankInt)];
                        NSString *poundSign = @"#";
                        NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, newRankStr];
                        self.rankLabel.text = rankString;
                        [self.currentBridge setObject:[NSNumber numberWithInt:0] forKey:@"updatedRankNumberForOtherUser"];
                        [self.currentBridge saveInBackground];
                    }
                    
                } else {
                    NSNumber *rankNumber = [currentUser objectForKey:@"rank"];
                    NSUInteger rankInt = [rankNumber integerValue];
                    NSString *rank = [NSString stringWithFormat:@"%@",  @(rankInt)];
                    NSString *poundSign = @"#";
                    NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, rank];
                    self.rankLabel.text = rankString;
                }
            }
            self.bridgeFlag3 = YES;
            if (self.bridgeFlag1 == YES && self.bridgeFlag2 == YES && self.bridgeFlag3 == YES) {
                if (self.currentUserLosses != 0) {
                    CGFloat ratioFloat = self.currentUserWins/self.currentUserLosses;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                } else {
                    CGFloat ratioFloat = self.currentUserWins;
                    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
                    self.ratioLabel.text = ratioStr;
                    [currentUser setObject:ratioStr forKey:@"ratio"];
                    [currentUser saveInBackground];
                }
            }
            if (self.bridgeFlag1 == YES && self.bridgeFlag2 == YES && self.bridgeFlag3 == YES && [self.currentBridge objectForKey:@"thirdUserRankNumber"] == [NSNumber numberWithInt:0] && [self.currentBridge objectForKey:@"updatedRankNumberForOtherUser"] == [NSNumber numberWithInt:0]) {
                [self.currentBridge deleteInBackground];
            }
        }];
    }
    
    NSNumber *currentUserRankNumber = [currentUser objectForKey:@"rank"];
    NSUInteger currentUserRankInt = [currentUserRankNumber integerValue];
    
    PFQuery *query = [PFUser query];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [query orderByAscending:@"rank"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                NSLog(@"what what what what what what what");
                if (self.ladder != nil) {
                    self.ladder= nil;
                }
                if (self.thirdUser != nil) {
                    self.thirdUser = nil;
                }
                NSLog(@"currentUserRankInt -> %d", currentUserRankInt);
                self.ladder = [[NSMutableArray alloc] initWithArray:objects];
                self.thirdUser = self.ladder[currentUserRankInt - 2];
                NSLog(@"THIS IS THE THIRD USER %@", self.thirdUser.username);
            }
        }];
        
    }
    
    [self checkForExistingChallenge];
    
    [self retrievePastChallenges];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    // return [self.messages count];
    return [self.pastChallenges count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"why";
    myPastChallengesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureBasicCell:cell atIndexPath:indexPath];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    return cell;
}


#pragma mark - good ol' helpers

- (void)retrievePastChallenges {
    /* Retrieving all messages */
    PFQuery *query1 = [PFQuery queryWithClassName:@"PastChallenges"];
    PFQuery *query2 = [PFQuery queryWithClassName:@"PastChallenges"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        //[query whereKey:@"loser" equalTo:[PFUser currentUser].username];
        [query1 whereKey:@"winner" equalTo:[PFUser currentUser].username];
        [query2 whereKey:@"loser" equalTo:[PFUser currentUser].username];
        PFQuery *mainQuery = [PFQuery orQueryWithSubqueries:@[query1,query2]];
        [mainQuery orderByAscending:@"createdAt"];
        [mainQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.pastChallenges != nil) {
                    self.pastChallenges = nil;
                }
                self.pastChallenges = [[NSMutableArray alloc] initWithArray:objects];
                
                
                NSLog(@"pastChallenges count %d", [self.pastChallenges count]);
                
                [self.tableView reloadData];
            }
            
            if ([self.refreshControl isRefreshing]) { //ENDS REFRESHING
                [self.refreshControl endRefreshing];
            }
        }];
        
    }
}

//you get a reference to the item at the indexPath, which then gets and sets the titleLabel and subtitleLabel texts on the cell
- (void)configureBasicCell:(myPastChallengesCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PFObject *pastChallenge = [self.pastChallenges objectAtIndex:indexPath.row];
    NSString *loser = [pastChallenge objectForKey:@"loser"];
    NSString *winner = [pastChallenge objectForKey:@"winner"];
    NSString *challenger = [pastChallenge objectForKey:@"challenger"];
    NSString *challengee = [pastChallenge objectForKey:@"challengee"];
    NSString *pastChallengeString;
    cell.challengerLabel.text = challenger;
    cell.challengeeLabel.text = challengee;
    if ([loser isEqualToString:[PFUser currentUser].username]) {
        
        cell.resultsLabel.text = @"L";
        
    } else {
        cell.resultsLabel.text = @"W";
    }
    //[self setPostForCell:cell item:pastChallengeString];
}

//set labels
- (void)setPostForCell:(UITableViewCell *)cell item:(NSString *)item {
    NSString *text = item;
    cell.textLabel.text = text;
}

- (void)checkForExistingChallenge {
    self.challenges = nil;
    self.currentChallenge = nil;
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
            
            NSLog(@"current challenge what the fuck %@", [self.currentChallenge objectForKey:@"challenger"]);
            
            if (self.currentChallenge == nil) {
                NSLog(@"current challenge what the fuck part 2 %@", [self.currentChallenge objectForKey:@"challenger"]);
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
    self.winLossFlag = NO;
    self.recordFlag = NO;
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
        
        NSString *challenger = [self.currentChallenge objectForKey:@"challenger"];
        NSString *challengee = [self.currentChallenge objectForKey:@"challengee"];
        NSNumber *currentUserRankNumber = [currentUser objectForKey:@"rank"];
        NSUInteger currentUserRankInt = [currentUserRankNumber integerValue];
        
        NSString *currentUserRank = [NSString stringWithFormat:@"%@",  @(currentUserRankInt)];
        NSString *poundSign = @"#";
        NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, currentUserRank];
        
        NSNumber *otherUserRankNumber = [self.otherUser objectForKey:@"rank"];
        NSUInteger otherUserRankInt = [otherUserRankNumber integerValue];
        
        NSNumber *thirdUserRankNumber;
        
        NSLog(@" otherUserRankInt from Brexton: %d", otherUserRankInt); //1
        NSLog(@" currentUserRankInt from Brexton %d", currentUserRankInt); //2
        
        NSLog(@"currentUser.username from Brexton %@", currentUser.username);

        
        if ([currentUser.username isEqualToString:challenger]) {
            //handle case when challengee is only one rank away -> swap places
            NSLog(@"the names are equal!");
            if (currentUserRankInt - otherUserRankInt == 1) { //2 - 1
                NSLog(@"passed the conditional o yea");
                NSNumber *temp = currentUserRankNumber; //2
                currentUserRankNumber = otherUserRankNumber; //1
                [currentUser setObject:currentUserRankNumber forKey:@"rank"];
                [currentUser saveInBackground];
                
                otherUserRankNumber = temp; //2
                
                
                //upload to bridge
                
                
            } else if (currentUserRankInt - otherUserRankInt == 2) {
                NSNumber *temp1 = currentUserRankNumber; //3
                int temp1Int = [temp1 intValue];
                NSLog(@" temp1Int = %d", temp1Int); //good
                
                int thirdUserRankNumberInt = temp1Int - 1; //2
                NSLog(@" thirdUserRankNumberInt = %d", thirdUserRankNumberInt);
                
                thirdUserRankNumber = [NSNumber numberWithInt:thirdUserRankNumberInt];
                currentUserRankNumber = otherUserRankNumber; //1
                NSLog(@" otherUserRankNumber = %d", otherUserRankInt);
                
                otherUserRankNumber = thirdUserRankNumber;
                
                
                thirdUserRankNumber = temp1;
                
                
                [currentUser setObject:currentUserRankNumber forKey:@"rank"];
                [currentUser saveInBackground];
                
                
                // you have the third user and the rankings -> push to bridge
                
            } else {
                //otherUserRankNumber stays the exact same
            }
        }
        
        NSLog(@"THIS IS THE THIRD USER OUTSIDE %@", self.thirdUser.username);
        
        //LOSIN.
        NSNumber *otherUserLosses = [self.otherUser objectForKey:@"losses"];
        NSUInteger *otherUserLossesInt = [otherUserLosses integerValue] + 1;
        otherUserLosses = [NSNumber numberWithInteger:otherUserLossesInt];
        
        NSString *messageStupid = @"finished challenge";
        NSData *fileData = [messageStupid dataUsingEncoding:NSUTF8StringEncoding];
        NSString *fileName = @"finishedChallenge";
        NSString *fileType = @"string";
        
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Can't bridge at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                NSLog(@" did i at least make it in here part O COME ON");
                PFObject *messageThe = [PFObject objectWithClassName:@"Bridge"];
                [messageThe setObject:file forKey:@"file"]; //Creating classes to save message to in parse
                [messageThe setObject:fileType forKey:@"fileType"];
                [messageThe setObject:[self.otherUser objectId] forKey:@"userObjectId"];
                [messageThe setObject:self.otherUser.username forKey:@"username"];
                [messageThe setObject:otherUserLosses forKey:@"updatedLosses"];
                [messageThe setObject:otherUserRankNumber forKey:@"updatedRankNumberForOtherUser"];
                
                if (self.thirdUser != nil) {
                    [messageThe setObject:self.thirdUser.username forKey:@"thirdUser"];
                    [messageThe setObject:thirdUserRankNumber forKey:@"thirdUserRankNumber"];
                }
                
                [messageThe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        NSLog(@" did i at least make it in here part 1");
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    } else {
                        //IT WORKED.
                        NSLog(@" did i at least make it in here part 2");
                        self.winLossFlag = YES;
                        if (self.recordFlag == YES && self.winLossFlag == YES) {
                            [self.currentChallenge deleteInBackground];
                        }
                    }
                }];
            }
        }];
        
        //RECORDING PAST.
        NSString *message1 = @"past challenge";
        NSData *fileData1 = [message1 dataUsingEncoding:NSUTF8StringEncoding];
        NSString *fileName1 = @"pastChallenge";
        NSString *fileType1 = @"string";
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd"];
        NSString *dateString = [dateFormat stringFromDate:today];
        
        PFFile *file1 = [PFFile fileWithName:fileName1 data:fileData1];
        
        [file1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Can't record past challenge at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                PFObject *message = [PFObject objectWithClassName:@"PastChallenges"];
                [message setObject:currentUser.username forKey:@"winner"]; //Creating classes to save message to in parse
                [message setObject:self.otherUser.username forKey:@"loser"];
                [message setObject:challenger forKey:@"challenger"];
                [message setObject:challengee forKey:@"challengee"];
                [message setObject:dateString forKey:@"dateString"];
                [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    } else {
                        //IT WORKED.
                        self.recordFlag = YES;
                        NSLog(@"record flag %d", self.recordFlag);
                        NSLog(@"winloss flag %d", self.winLossFlag);
                        if (self.recordFlag == YES && self.winLossFlag == YES) {
                            [self.currentChallenge deleteInBackground];
                        }
                    }
                }];
            }
        }];

        
        
        //[self.currentChallenge deleteInBackground];
    }
}

- (IBAction)loseButton:(id)sender {
    self.winLossFlag = NO;
    self.recordFlag = NO;
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
                        self.winLossFlag = YES;
                        if (self.recordFlag == YES && self.winLossFlag == YES) {
                            [self.currentChallenge deleteInBackground];
                        }
                    }
                }];
            }
        }];
        
        //RECORDING PAST.
        NSString *message1 = @"past challenge";
        NSData *fileData1 = [message1 dataUsingEncoding:NSUTF8StringEncoding];
        NSString *fileName1 = @"pastChallenge";
        NSString *fileType1 = @"string";
        NSString *challenger = [self.currentChallenge objectForKey:@"challenger"];
        NSString *challengee = [self.currentChallenge objectForKey:@"challengee"];
        
        //case is handled where the currentUser is the challenger and loses
        
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd"];
        NSString *dateString = [dateFormat stringFromDate:today];
        
        PFFile *file1 = [PFFile fileWithName:fileName1 data:fileData1];
        
        [file1 saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Can't record past challenge at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } else {
                PFObject *message = [PFObject objectWithClassName:@"PastChallenges"];
                [message setObject:currentUser.username forKey:@"loser"]; //Creating classes to save message to in parse
                [message setObject:self.otherUser.username forKey:@"winner"];
                [message setObject:challenger forKey:@"challenger"];
                [message setObject:challengee forKey:@"challengee"];
                [message setObject:dateString forKey:@"dateString"];
                [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alertView show];
                    } else {
                        //IT WORKED.
                        self.recordFlag = YES;
                        if (self.recordFlag == YES && self.winLossFlag == YES) {
                            [self.currentChallenge deleteInBackground];
                        }
                    }
                }];
            }
        }];
    }
}

//make same for viewDidLoad and viewWillAppear


@end
