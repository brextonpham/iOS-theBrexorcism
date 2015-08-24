//
//  ladderCell.m
//  theBrexorcism
//
//  Created by Brexton Pham on 8/21/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "ladderCell.h"
#import <Parse/Parse.h>
#import "challengeVC.h"

@implementation ladderCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)challengeButtonAction:(id)sender {
    [self.delegate ladderCell:self challengeButtonPressedForUser:self.challengedUser];
}
@end
