//
//  SettingsViewController.m
//  Vest
//
//  Created by David Cabrera on 1/7/14.
//  Copyright (c) 2014 HedgeCo. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    user = nil;
    
    if (userDefaults)
        user = [userDefaults objectForKey:@"user"];
    
    options = @{
                  @"Account": @{
                          @"Profile": @"ProfileViewController",
                          @"Notifications": @"NotificationsViewController",
                          @"Change Password": @"PasswordViewController",
                          @"Sign Out": @"SignOutViewController"
                          },
                  @"Support": @{
                          @"Help Center": @"HelpCenterViewController",
                          @"Legal Agreements": @"LegalAgreementsViewController",
                          @"Feedback": @"FeedbackViewController"
                          }
                  };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [options count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[options objectForKey:[[options allKeys] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *section = [options objectForKey:[[options allKeys] objectAtIndex:indexPath.section]];
    NSString *option = [[section allKeys] objectAtIndex:indexPath.row];
    
    [[cell textLabel] setText:option];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[options allKeys] objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *section = [options objectForKey:[[options allKeys] objectAtIndex:indexPath.section]];
    NSString *option = [[section allKeys] objectAtIndex:indexPath.row];
    
    if ([option isEqualToString:@"Sign Out"]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        if (userDefaults) {
            [userDefaults removeObjectForKey:@"user"];
            [userDefaults synchronize];
        }
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate reloadApp];
    }
    
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
