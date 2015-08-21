//
//  ViewController.h
//  theBrexorcism
//
//  Created by Brexton Pham on 8/18/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ladderVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) PFUser *selectedUser;
@property (nonatomic, strong) NSMutableArray *ladder;
@property NSUInteger currentUserRank;

- (IBAction)logOut:(id)sender;

@end

