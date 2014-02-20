//
//  ExploreViewController.m
//  Vest
//
//  Created by David Cabrera on 1/3/14.
//  Copyright (c) 2014 HedgeCo. All rights reserved.
//

#import "ExploreViewController.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController
@synthesize typeSegmentedControl, sortSegmentedControl;

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
    
    sortAscending = NO;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    user = nil;
    
    if (userDefaults)
        user = [userDefaults objectForKey:@"user"];
    
    [self fetchModels];
}

- (NSString *)checkNullOrEmpty:(NSString *)value {
    return (value == (id)[NSNull null] || value.length == 0 || [value isEqualToString:@"<null>"] ) ? @"--" : value;
}

- (double)checkNullOrEmptyForSort:(NSString *)value {
    return [[self checkNullOrEmpty:value] isEqualToString:@"--"] ? -9999.00 : [[value stringByReplacingOccurrencesOfString:@"%" withString:@""] doubleValue];
}

- (NSComparisonResult)compareDouble:(double)val1 to:(double)val2 {
    if(val1 > val2)
        return (NSComparisonResult)NSOrderedDescending;
    
    if(val1 < val2)
        return (NSComparisonResult)NSOrderedAscending;
    
    return (NSComparisonResult)NSOrderedSame;
}

- (NSComparisonResult)sortDictionariesOnDoubleKey:(NSString *)key dict1:(NSDictionary*)dict1 dict2:(NSDictionary*)dict2 {
    return [self compareDouble:
            [self checkNullOrEmptyForSort:[dict1 valueForKey:key]] to:
            [self checkNullOrEmptyForSort:[dict2 valueForKey:key]]
            ];
}

- (IBAction)changeType:(id)sender
{
    [self fetchModels];
}

- (IBAction)changeSort:(id)sender
{
    NSArray *unsorted = [models copy];
    
    switch ([sortSegmentedControl selectedSegmentIndex]) {
        case 1: {
            // 5day
            models = [unsorted sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dict1, NSDictionary *dict2) {
                return [self sortDictionariesOnDoubleKey:@"5day" dict1:dict1 dict2:dict2];
            }];
            break;
        }
        case 2: {
            // 30day
            models = [unsorted sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dict1, NSDictionary *dict2) {
                return [self sortDictionariesOnDoubleKey:@"30day" dict1:dict1 dict2:dict2];
            }];
            break;
        }
        default:
            // today
            models = [unsorted sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dict1, NSDictionary *dict2) {
                return ![self sortDictionariesOnDoubleKey:@"today" dict1:dict1 dict2:dict2];
            }];
            break;
    }
    
    [self.tableView reloadData];
}

- (void)fetchModels
{
    NSString *api = @"http://hcv-api.gopagoda.com";
    NSString *url = [[NSString alloc] init];
    
    switch ([typeSegmentedControl selectedSegmentIndex]) {
        case 1:
            // trending
            url = [NSString stringWithFormat:@"%@/models/trending", api];
            break;
        case 2:
            // watching
            url = [NSString stringWithFormat:@"%@/members/%@/models", api, [user objectForKey:@"id"]];
            break;
        default:
            url = [NSString stringWithFormat:@"%@/models", api];
            break;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    // clear table
    models = nil;
    [self.tableView reloadData];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // NSLog(@"Data: %@", responseObject);
        models = responseObject;
        [self changeSort:self];
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
    return [models count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ModelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    NSDictionary *model = [models objectAtIndex:indexPath.row];
    
    [[cell textLabel] setText:[model objectForKey:@"title"]];
    [[cell detailTextLabel] setText:
     [NSString stringWithFormat:@"TODAY %@  5 DAY %@  30 DAY %@",
      [self checkNullOrEmpty:[model objectForKey:@"today"]],
      [self checkNullOrEmpty:[model objectForKey:@"5day"]],
      [self checkNullOrEmpty:[model objectForKey:@"30day"]]
      ]
     ];
    
    return cell;
}

 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     // currently not used
     ModelViewController *modelViewController = (ModelViewController *)[segue destinationViewController];
     [modelViewController setModel:[models objectAtIndex:[[self.tableView indexPathForSelectedRow] row]]];
 }

@end