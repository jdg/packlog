//
//  JournalController.m
//  PackLog
//
//  Created by Jonathan George on 10/9/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import "PackLogAppDelegate.h"
#import "JournalController.h"
#import "SettingsController.h"
#import "UserController.h"

#import "EntryCell.h"

@implementation JournalController

@synthesize tableView, currently, navigationBar, navigationItem, entryCell;

- (void) displaySettings:(id)sender
{
	SettingsController *l = [[SettingsController alloc] initWithNibName:@"SettingsView" bundle: nil];
	[self presentModalViewController:l animated:YES];
}

- (IBAction)updateJournal:(id)sender
{
	[manager sendUpdateToJournal:self.currently.text];
	[self.currently resignFirstResponder];
	self.currently.text = @"";
	[self refreshJournalEntries:nil];
	[self displayRefreshButton];
}

- (IBAction)touchCancel:(id)sender
{
	NSLog(@"touchCancel");
	[self.currently resignFirstResponder];
	self.currently.text = @"";

	[self displayRefreshButton];
}

- (void)refreshJournalEntries:(id)sender
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(journalRefreshNotificationReceived:) name:@"JournalRefreshNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsNeedDisplayedNotificationReceived:) name:@"SettingsNeedDisplayedNotification" object:nil];

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
	return [[manager journalEntries] count];
}

- (CGSize)getSizeOfBody:(NSString *)body {
	CGSize size = CGSizeMake(210.0,2000.0);
	return [[NSString stringWithFormat:@"%@", body] sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
	CGSize csz = [self getSizeOfBody:[[[manager journalEntries] objectAtIndex:indexPath.row] objectForKey:@"body"]];
	return csz.height + 52;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EntryCell";

	EntryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"EntryCell" owner:self options:nil];
		[cell = entryCell retain];
		entryCell = nil; // make sure this can't be re-used accidentally
    }

	[cell setData:[[manager journalEntries] objectAtIndex:indexPath.row] messageKey:@"body"];

    return cell;
}

/*
 To conform to Human Interface Guildelines, since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"%@ viewDidLoad", self);

	[self displayRefreshButton];
	[self displaySettingsButton];

	self.currently.font = [UIFont boldSystemFontOfSize:22.0];
	manager = [[JournalManager alloc] init];

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
    [super viewWillAppear:animated];

	[self checkSettings];

	if ([[manager journalEntries] count] == 0) {
		[self refreshJournalEntries:nil];
	}
}

- (void)viewDidAppear:(BOOL)animated {
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

- (void)journalRefreshNotificationReceived:(id)notification
{
	[tableView reloadData];
	[self checkSettings];
}

- (void)settingsNeedDisplayedNotificationReceived:(id)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SettingsNeedDisplayedNotification" object:nil];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login failed" message:@"Need help?  E-mail support@appremix.com"
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
	[self displaySettings:nil];
}

@end
