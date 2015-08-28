//
//  ladderCell.h
//  theBrexorcism
//
//  Created by Brexton Pham on 8/21/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class ladderCell;

@protocol LadderCellDelegate <NSObject>
- (void)ladderCell:(ladderCell*)cell challengeButtonPressedForUser:(PFUser*)user;
@end

@interface ladderCell : UITableViewCell

@property BOOL challengeMaterial;
@property (weak, nonatomic) IBOutlet UIButton *challengeButtonOutlet;
@property (strong, nonatomic) PFUser *challengedUser;
@property (nonatomic, weak) id<LadderCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratioLabel;


- (IBAction)challengeButtonAction:(id)sender;


@end
