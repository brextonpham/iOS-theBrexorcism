//
//  challengeBrexceptVC.m
//  theBrexorcism
//
//  Created by Brexton Pham on 8/25/15.
//  Copyright (c) 2015 Brexton Pham. All rights reserved.
//

#import "challengeBrexceptVC.h"
#import <Parse/Parse.h>

@interface challengeBrexceptVC ()

@end

@implementation challengeBrexceptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"what %@", [self.notYetChallenge objectForKey:@"objectId"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)noButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)yesButton:(id)sender {
    [self.notYetChallenge setObject:@"Yes" forKey:@"Accepted"];
    [self.notYetChallenge saveInBackground];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
@end
