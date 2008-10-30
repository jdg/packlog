//
//  UserController.m
//  PackLog
//
//  Created by Jonathan George on 10/13/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import "PackLogAppDelegate.h"
#import "UserController.h"


@implementation UserController

- (void)refreshUserEntries:(id)sender
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userRefreshNotificationReceived:) name:@"UserRefreshNotification" object:nil];
	[manager fetch];
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];

	manager = [[UserManager alloc] init];
	[self refreshUserEntries:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"Choose your name from below:";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[manager userEntries] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }

	cell.text = [[[manager userEntries] objectAtIndex:indexPath.row] objectForKey:@"name"];
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	PackLogAppDelegate *appDelegate = (PackLogAppDelegate *)[[UIApplication sharedApplication] delegate];

	NSString *userId = [[[manager userEntries] objectAtIndex:indexPath.row] objectForKey:@"id"];

	[appDelegate saveUserId:userId];

	[self dismissModalViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"%@ viewWillAppear", self);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"%@ viewDidAppear", self);
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	NSLog(@"%@ didReceiveMemoryWarning", self);
}

- (void)userRefreshNotificationReceived:(id)notification
{
	NSLog(@"userRefreshNotificationReceived");
	[self.tableView reloadData];
}


- (void)dealloc {
    [super dealloc];
}

@end

