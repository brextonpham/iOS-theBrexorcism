//
//  meVC.m
//  theBrexorcism
//
//  Created by Brexton Pham on 8/24/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "meVC.h"

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
    NSLog(@"%.2f hi float", ratioFloat);
    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
    NSLog(@"%@ this is the ratioStr", ratioStr);
    self.ratioLabel.text = ratioStr;
    
    NSNumber *rankNumber = [currentUser objectForKey:@"rank"];
    NSUInteger rankInt = [rankNumber integerValue];
    NSString *rank = [NSString stringWithFormat:@"%@",  @(rankInt)];
    NSString *poundSign = @"#";
    NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, rank];
    
    self.rankLabel.text = rankString;
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
    NSLog(@"%.2f hi float", ratioFloat);
    NSString *ratioStr = [NSString stringWithFormat:@"%.2f", ratioFloat];
    NSLog(@"%@ this is the ratioStr", ratioStr);
    self.ratioLabel.text = ratioStr;
    
    NSNumber *rankNumber = [currentUser objectForKey:@"rank"];
    NSUInteger rankInt = [rankNumber integerValue];
    NSString *rank = [NSString stringWithFormat:@"%@",  @(rankInt)];
    NSString *poundSign = @"#";
    NSString *rankString = [NSString stringWithFormat:@"%@%@", poundSign, rank];
    
    self.rankLabel.text = rankString;
    
    if ([self checkForExistingChallenge]) {
        [self performSegueWithIdentifier:@"showBrexcept" sender:self];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)checkForExistingChallenge {
    int challengesCount;
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
                        [self.challenges addObject:objects[i]];
                    }
                }
                NSLog(@"Number of items in my second array is %d", [self.challenges count]);
            }
            int challengesCount = [self.challenges count];
            NSLog(@"Number of items in my second array (part 2) is %d", challengesCount);
        }];
    }
    if (challengesCount > 0) {
        return YES;
    } else {
        return NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
