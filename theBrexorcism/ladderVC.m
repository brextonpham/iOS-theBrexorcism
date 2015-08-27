//
//  ViewController.m
//  theBrexorcism
//
//  Created by Brexton Pham on 8/18/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "ladderVC.h"
#import "ladderCell.h"
#import "challengeVC.h"

@interface ladderVC () <LadderCellDelegate>



@end

@implementation ladderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Make self the delegate and datasource of the tableview
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    //check to see if user is logged in already
    
    PFUser *currentUser = [PFUser currentUser];
    NSLog(@"%@",[[PFUser currentUser] objectId]);
    
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    } else {
        //initial segue is to login screen at launch
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    //refresh screen!
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(retrieveLadder) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
        [self retrieveLadder];
        
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
    return [self.ladder count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    ladderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [self configureBasicCell:cell atIndexPath:indexPath];
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    //[cell.challengeButtonOutlet setBackgroundColor:[UIColor redColor]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedUser = [self.ladder objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showLogin"]) { //go to login page
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    } else if ([segue.identifier isEqualToString:@"showDetail"]) { // go to yak
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        //YakDetailVC *detailViewController = (YakDetailVC *)segue.destinationViewController;
        //detailViewController.message = self.selectedMessage;
    }  else if ([segue.identifier isEqualToString:@"showChallenge"]) {
        challengeVC *challengeViewController = (challengeVC *)segue.destinationViewController;
        challengeViewController.currentUser = [PFUser currentUser];
        challengeViewController.challengedUser = self.challengedUser;
    }
}

#pragma mark - LadderCellDelegate

- (void)ladderCell:(ladderCell *)cell challengeButtonPressedForUser:(PFUser *)user {
    self.challengedUser = user;
}

#pragma mark - helper methods

- (void)retrieveLadder {
    /* Retrieving all messages */
    PFQuery *query = [PFUser query];
    if ([[PFUser currentUser] objectId] == nil) {
        NSLog(@"No objectID");
    } else {
        [query orderByAscending:@"rank"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            } else {
                if (self.ladder != nil) {
                    self.ladder= nil;
                }
                self.ladder = [[NSMutableArray alloc] initWithArray:objects];
                
                PFUser *currentUser = [PFUser currentUser];
                for (PFUser *user in self.ladder) {
                    if ([user.username isEqualToString:currentUser.username]) {
                        NSNumber *rank = [user objectForKey:@"rank"];
                        self.currentUserRank = [rank integerValue];
                    }
                }
                
                [self.tableView reloadData];
            }
            
            if ([self.refreshControl isRefreshing]) { //ENDS REFRESHING
                [self.refreshControl endRefreshing];
            }
        }];
        
    }
}

//you get a reference to the item at the indexPath, which then gets and sets the titleLabel and subtitleLabel texts on the cell
- (void)configureBasicCell:(ladderCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    PFUser *user = [self.ladder objectAtIndex:indexPath.row];
    NSString *name = user.username;
    NSNumber *rank = [user objectForKey:@"rank"];
    NSUInteger rankInt = [rank integerValue];
    NSString *rankString = [NSString stringWithFormat:@"%@",  @(rankInt)];
    NSString *text = [NSString stringWithFormat: @"%@ %@", rankString, name];
    
    cell.delegate = self;
    
    if (self.currentUserRank - rankInt == 1 || self.currentUserRank - rankInt == 2) {
    //if (rankInt - self.currentUserRank == 1 || rankInt - self.currentUserRank == 2) {
        //cell.backgroundColor = [UIColor redColor];
        cell.challengeMaterial = YES;
        cell.challengedUser = user;
        cell.challengeButtonOutlet.hidden = NO;
    } else {
        cell.challengeButtonOutlet.hidden = YES;
    }
    
    [self setPostForCell:cell item:text];
}

//set labels
- (void)setPostForCell:(ladderCell *)cell item:(NSString *)item {
    NSString *name = item;
    cell.textLabel.text = name;
}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}
@end
