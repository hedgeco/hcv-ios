//
//  LoginViewController.m
//  Vest
//
//  Created by David Cabrera on 1/8/14.
//  Copyright (c) 2014 HedgeCo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate reloadApp];
}

- (IBAction)loginAction:(id)sender
{
    // @todo: login using AFNetworking to REST endpoint with credentials
    
    // @todo: remove this dummy user, added just for testing
    NSDictionary *user = @{
       @"id" : @"0t2CglGMu8sQ78bqzAZtARdl3QeFTKTvsMED",
       @"drupal_id" : @"NULL",
       @"username" : @"dave@rerainc.com",
       @"password" : @"QEb2ryWMKA/gVSMmzndyu8uaorlK2wLGMwSXoqmDYPg=",
       @"email" : @"dave@rerainc.com",
       @"date" : @"2014-01-03 17:43:21",
       @"status" : @"0",
       @"reset" : @"0",
       @"notification_preference" : @"email-html",
       @"name_first" : @"David",
       @"name_last" : @"Cabrera",
       @"phone" : @"561-568-7888",
       @"address" : @"116 Abaco Dr.",
       @"city" : @"Palm Springs",
       @"state" : @"FL",
       @"zip" : @"33461",
       @"company" : @"HedgeCo LLC",
       @"position" : @"Dev",
       @"type" : @"individual-investors",
       @"security_question1" : @"what-is-the-name-of-your-favorite-childhood-friend",
       @"security_answer1" : @"foo",
       @"security_question2" : @"in-what-city-does-your-nearest-sibling-live",
       @"security_answer2" : @"bar"
   };
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (userDefaults) {
        [userDefaults setObject:user forKey:@"user"];
        [userDefaults synchronize];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
