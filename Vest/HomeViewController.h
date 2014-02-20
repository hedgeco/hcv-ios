//
//  HomeViewController.h
//  Vest
//
//  Created by David Cabrera on 1/3/14.
//  Copyright (c) 2014 HedgeCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UITableViewController {
    NSDictionary *user;
    NSArray *accounts;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *typeSegmentedControl;

- (void)fetchAccounts;
- (IBAction)changeType:(id)sender;

@end
