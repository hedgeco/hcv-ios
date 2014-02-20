//
//  ExploreViewController.h
//  Vest
//
//  Created by David Cabrera on 1/3/14.
//  Copyright (c) 2014 HedgeCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelViewController.h"

@interface ExploreViewController : UITableViewController {
    NSDictionary *user;
    NSArray *models;
    BOOL sortAscending;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *typeSegmentedControl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sortSegmentedControl;

- (void)fetchModels;
- (IBAction)changeType:(id)sender;
- (IBAction)changeSort:(id)sender;

@end
