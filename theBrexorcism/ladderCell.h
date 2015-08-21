//
//  ladderCell.h
//  theBrexorcism
//
//  Created by Brexton Pham on 8/21/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ladderCell : UITableViewCell

@property BOOL challengeMaterial;
@property (weak, nonatomic) IBOutlet UIButton *challengeButton;

- (IBAction)challengeButton:(id)sender;


@end
