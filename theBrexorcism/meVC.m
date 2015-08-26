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
    
    NSNumber *wins = [currentUser objectForKey:@"wins"];
    NSUInteger winsInt = [wins integerValue];
    NSString *winsStr = [NSString stringWithFormat:@"%@", @(winsInt)];
    self.winsLabel.text = winsStr;
    
    NSNumber *losses = [currentUser objectForKey:@"losses"];
    NSInteger lossesInt = [losses longValue];
    NSString *lossesStr = [NSString stringWithFormat:@"%ld", (long)lossesInt];
    self.lossesLabel.text = lossesStr;
    
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@ on meVC", currentUser.username);
    self.currentUserNameLabel.text = currentUser.username;
    
    NSNumber *wins = [currentUser objectForKey:@"wins"];
    NSUInteger winsInt = [wins integerValue];
    NSString *winsStr = [NSString stringWithFormat:@"%@", @(winsInt)];
    self.winsLabel.text = winsStr;
    
    NSNumber *losses = [currentUser objectForKey:@"losses"];
    NSInteger lossesInt = [losses longValue];
    NSString *lossesStr = [NSString stringWithFormat:@"%ld", (long)lossesInt];
    self.lossesLabel.text = lossesStr;
    
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
    NSLog(@"shadness: %@", [self.currentChallenge objectForKey:@"challengee"]);
    
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
                } else {
                    self.currentChallengeNameLabel.text = challengerName;
                }
            }
        }];
    }
    //query isn't fast enough. fix this in challenge class too.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)winButton:(id)sender {
    if (![self.currentChallengeNameLabel.text isEqualToString:@"N/A"]) {
        self.currentChallengeNameLabel.text = @"N/A";
        [self.currentChallenge deleteInBackground];
        PFUser *currentUser = [PFUser currentUser];
        NSNumber *wins = [currentUser objectForKey:@"wins"];
        NSUInteger winsInt = [wins integerValue] + 1;
        NSString *winsStr = [NSString stringWithFormat:@"%@", @(winsInt)];
        self.winsLabel.text = winsStr;
        
        wins = [NSNumber numberWithInteger:winsInt];
        [currentUser setObject:wins forKey:@"wins"];
        [currentUser save];
        
        
    }
}

- (IBAction)loseButton:(id)sender {
    self.currentChallengeNameLabel.text = @"N/A";
    [self.currentChallenge deleteInBackground];
    
}
@end
