//
//  HomeViewController.m
//  Vest
//
//  Created by David Cabrera on 1/3/14.
//  Copyright (c) 2014 HedgeCo. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize typeSegmentedControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    user = nil;
    
    if (userDefaults)
        user = [userDefaults objectForKey:@"user"];
    
    [self fetchAccounts];
}

- (IBAction)changeType:(id)sender
{
    [self fetchAccounts];
}

- (void)fetchAccounts
{
    NSString *api = @"http://hcv-api.gopagoda.com";
    NSString *url = [[NSString alloc] init];
    
    switch ([typeSegmentedControl selectedSegmentIndex]) {
        case 1:
            url = [NSString stringWithFormat:@"%@/members/%@/accounts/Non-Active", api, [user objectForKey:@"id"]];
            break;
        default:
            url = [NSString stringWithFormat:@"%@/members/%@/accounts/Active", api, [user objectForKey:@"id"]];
            break;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // clear table
    accounts = nil;
    [self.tableView reloadData];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"Data: %@", responseObject);
        accounts = responseObject;
        [self.tableView reloadData];
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
    }];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *account = [accounts objectAtIndex:indexPath.row];
    
    [[cell textLabel] setText:[account objectForKey:@"title"]];
    
    return cell;
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