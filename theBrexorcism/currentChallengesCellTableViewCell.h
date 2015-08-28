//
//  currentChallengesCellTableViewCell.h
//  theBrexorcism
//
//  Created by Brexton Pham on 8/28/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface currentChallengesCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *challengerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengeeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
