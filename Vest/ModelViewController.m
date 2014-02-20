//
//  ModelViewController.m
//  Vest
//
//  Created by David Cabrera on 1/9/14.
//  Copyright (c) 2014 HedgeCo. All rights reserved.
//

#import "ModelViewController.h"

@interface ModelViewController ()

@end

@implementation ModelViewController
@synthesize model, investButton, watchButton;

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
    
    // set view title
    
    [self.navigationItem setTitle:[model objectForKey:@"ticker"]];
    
    // get user
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    user = nil;
    
    if (userDefaults)
        user = [userDefaults objectForKey:@"user"];
    
    // check if watching
    
    NSString *api = @"http://hcv-api.gopagoda.com";
    NSString *url = [NSString stringWithFormat:@"%@/members/%@/models/%@", api, [user objectForKey:@"id"], [model objectForKey:@"id"]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"Data: %@", responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            NSDictionary *payload = [responseObject objectForKey:@"payload"];
            NSString *watchingString = [payload objectForKey:@"watching"];
            BOOL watching = [watchingString boolValue];
            [self setWatching:watching];
        }
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [hud hide:YES];
    }];
    
    // populate fields dictionary for table rows
    
    fields = [[NSMutableDictionary alloc] init];
    
    for (NSString *key in [model allKeys]) {
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[0-9]+$'"];
        if ( !( [numberPredicate evaluateWithObject:key] || [key isEqualToString:@"overview"] || [key isEqualToString:@"id"] ) ) {
            NSString *value = [self checkNullOrEmpty:[model objectForKey:key]];
            [fields setObject:value forKey:key];
        }
    }
    [self.tableView reloadData];
}

- (NSString *)checkNullOrEmpty:(NSString *)value {
    return (value == (id)[NSNull null] || value.length == 0 || [value isEqualToString:@"<null>"] ) ? @"--" : value;
}

- (NSString*)watchButtonTitleForWatching:(BOOL)watching {
    return watching ? @"Unwatch" : @"Watch";
}

- (UIColor*)watchButtonColorForWatching:(BOOL)watching {
    return watching ? [UIColor redColor] : [[UIButton buttonWithType:UIButtonTypeSystem] titleColorForState:UIControlStateNormal];
}

- (void)setWatching:(BOOL)watching {
    watchingModel = watching;
    
    // update UI
    
    [watchButton setTitle:[self watchButtonTitleForWatching:watching]];
    [watchButton setTitleTextAttributes:@{ NSForegroundColorAttributeName: [self watchButtonColorForWatching:watching] } forState:UIControlStateNormal];
}

- (IBAction)changeWatching:(id)sender {
    BOOL watching = !watchingModel;
    
    NSString *api = @"http://hcv-api.gopagoda.com";
    NSString *url = [[NSString alloc] init];
    
    if (watching)
        url = [NSString stringWithFormat:@"%@/members/%@/models/%@", api, [user objectForKey:@"id"], [model objectForKey:@"id"]];
    else
        url = [NSString stringWithFormat:@"%@/members/%@/models/%@/remove", api, [user objectForKey:@"id"], [model objectForKey:@"id"]];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            [self setWatching:watching];
        }
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
    return [fields count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FieldCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    NSString *key = [fields allKeys][indexPath.row];
    NSString *value = [fields objectForKey:key];
    
    [[cell textLabel] setText:key];
    [[cell detailTextLabel] setText:value];
    
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
