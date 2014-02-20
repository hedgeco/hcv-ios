//
//  ModelViewController.h
//  Vest
//
//  Created by David Cabrera on 1/9/14.
//  Copyright (c) 2014 HedgeCo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelViewController : UITableViewController {
    NSDictionary *user;
    NSMutableDictionary *fields;
    BOOL watchingModel;
}

@property (nonatomic, retain) NSMutableDictionary *model;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *watchButton;
@property (nonatomic, retain) IBOutlet UIButton *investButton;

@end
