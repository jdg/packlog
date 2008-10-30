//
//  StatusController.m
//  PackLog
//
//  Created by Jonathan George on 10/10/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import "PackLogAppDelegate.h"
#import "StatusController.h"
#import "UserController.h"
#import "SettingsController.h"

#import "EntryCell.h"

@implementation StatusController

@synthesize statusTableView, statusEntry, entryCell;

- (void) displaySettings:(id)sender
{
	SettingsController *l = [[SettingsController alloc] initWithNibName:@"SettingsView" bundle: nil];
	[self presentModalViewController:l animated:YES];
}

- (IBAction)updateJournal:(id)sender
{
	[manager sendUpdateToJournal:self.statusEntry.text];
	[self.statusEntry resignFirstResponder];
	self.statusEntry.text = @"";
	[self refreshJournalEntries:nil];

	[self displayRefreshButton];
}

- (IBAction)touchCancel:(id)sender
{
	NSLog(@"touchCancel");
	[self.statusEntry resignFirstResponder];
	self.statusEntry.text = @"";
	
	[self displayRefreshButton];
}

- (void)refreshJournalEntries:(id)sender
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusRefreshNotificationReceived:) name:@"StatusRefreshNotification" object:nil];
	[manager fetch];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	[self displayCancelButton];
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[manager statusEntries] count];
}

- (CGSize)getSizeOfBody:(NSString *)body {
	CGSize size = CGSizeMake(210.0,2000.0);
	return [[NSString stringWithFormat:@"%@", body] sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
	CGSize csz = [self getSizeOfBody:[[[manager statusEntries] objectAtIndex:indexPath.row] objectForKey:@"message"]];
	return csz.height + 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EntryCell";
	
	EntryCell *cell = [statusTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"EntryCell" owner:self options:nil];
		[cell = entryCell retain];
		entryCell = nil; // make sure this can't be re-used accidentally
    }
	
	[cell setData:[[manager statusEntries] objectAtIndex:indexPath.row] messageKey:@"message"];
	
    return cell;
}

/*
 To conform to Human Interface Guildelines, since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)viewDidLoad {
	NSLog(@"%@ viewDidLoad", self);
    [super viewDidLoad];
	
	[self displayRefreshButton];
	[self displaySettingsButton];
	self.statusEntry.font = [UIFont boldSystemFontOfSize:22.0];

	manager = [[StatusManager alloc] init];
	[self checkSettings];
}

- (void)checkSettings {
	PackLogAppDelegate *appDelegate = (PackLogAppDelegate *)[[UIApplication sharedApplication] delegate];
	if ([appDelegate.subdomain isEqualToString:@""] || [appDelegate.apiKey isEqualToString:@""]
		|| appDelegate.subdomain == nil || appDelegate.apiKey == nil) {
		[self displaySettings:nil];
	} else if ([appDelegate.userId isEqualToString:@""] || appDelegate.userId == nil) {
		UserController *l = [[UserController alloc] initWithNibName:@"UserView" bundle: nil];
		[self presentModalViewController:l animated:YES];
	}
}

- (void)displaySettingsButton {
	UIBarButtonItem *settingsButton = [[[UIBarButtonItem alloc]
										initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered target:self action:@selector(displaySettings:)] autorelease];
	self.navigationItem.leftBarButtonItem = settingsButton;
}

- (void)displayRefreshButton {
	UIBarButtonItem *refreshButton = [[[UIBarButtonItem alloc]
									   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
									   target:self action:@selector(refreshJournalEntries:)] autorelease];
	self.navigationItem.rightBarButtonItem = refreshButton;	
}

- (void)displayCancelButton {
	UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc]
									  initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
									  target:self action:@selector(touchCancel:)] autorelease];
	self.navigationItem.rightBarButtonItem = cancelButton;	
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"%@ viewWillAppear", self);
    [super viewWillAppear:animated];

	if ([[manager statusEntries] count] == 0) {
		[self refreshJournalEntries:nil];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"%@ viewDidAppear", self);
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	NSLog(@"%@ didReceiveMemoryWarning", self);
}

- (void)dealloc {
    [super dealloc];
}

- (void)statusRefreshNotificationReceived:(id)notification
{
	[statusTableView reloadData];
	[self checkSettings];
}

@end
