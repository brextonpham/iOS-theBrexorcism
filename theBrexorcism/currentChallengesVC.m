//
//  currentChallengesVC.m
//  theBrexorcism
//
//  Created by Brexton Pham on 8/24/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "currentChallengesVC.h"
#import "currentChallengesCellTableViewCell.h"

@interface currentChallengesVC ()

@end

@implementation currentChallengesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Make self the delegate and datasource of the tableview
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    //refresh screen!
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveChallenges) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
        [self retrieveChallenges];
        
    } else {
        //initial segue is to login screen at launch
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
    return [self.challenges count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"whoAreYou";
    currentChallengesCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureBasicCell:cell atIndexPath:indexPath];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    return cell;
}


#pragma mark - helper methods

- (void)retrieveChallenges {
    /* Retrieving all messages */
    PFQuery *query = [PFQuery queryWithClassName:@"Challenges"];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [query orderByAscending:@"createdAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.challenges != nil) {
                    self.challenges = nil;
                }
                self.challenges = [[NSMutableArray alloc] initWithArray:objects];
                
                NSLog(@"challenges count %d", [self.challenges count]);
                
                [self.tableView reloadData];
            }
            
            if ([self.refreshControl isRefreshing]) { //ENDS REFRESHING
                [self.refreshControl endRefreshing];
            }
        }];
        
    }
}

//you get a reference to the item at the indexPath, which then gets and sets the titleLabel and subtitleLabel texts on the cell
- (void)configureBasicCell:(currentChallengesCellTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PFObject *challenge = [self.challenges objectAtIndex:indexPath.row];
    NSString *challenger = [challenge objectForKey:@"challenger"];
    NSString *challengee = [challenge objectForKey:@"challengee"];
    
    cell.challengeeNameLabel.text = challengee;
    cell.challengerNameLabel.text = challenger;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    [self setPostForCell:cell item:dateString];
}

//set labels
- (void)setPostForCell:(currentChallengesCellTableViewCell *)cell item:(NSString *)item {
    NSString *text = item;
    cell.dateLabel.text = text;
}


@end
