//
//  SettingsController.m
//  PackLog
//
//  Created by Jonathan George on 10/10/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import "PackLogAppDelegate.h"
#import "SettingsController.h"

#import "EditableCell.h"

#define kStdButtonWidth			300.0
#define kStdButtonHeight		40.0

@implementation SettingsController

@synthesize editableCell, tableView, saveButton, getTokenButton;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your Backpack API Token" message:@"Not sure what a Backpack API token is?  Touch 'Get Token' on the Settings screen to find out!"
												   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"PackLog Settings";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	PackLogAppDelegate *appDelegate = (PackLogAppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString *CellIdentifier = @"EditableCell";
	
	EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"EditableCell" owner:self options:nil];
		[cell = editableCell retain];
		editableCell = nil; // make sure this can't be re-used accidentally
		cell.textField.delegate = self;
    }

	if (indexPath.row == 0) {
		[cell setData:[NSDictionary dictionaryWithObjectsAndKeys:@"Subdomain", @"title", appDelegate.subdomain, @"textField", nil]];
		subdomain = cell.textField;
	} else if (indexPath.row == 1) {
		[cell setData:[NSDictionary dictionaryWithObjectsAndKeys:@"API Token", @"title", appDelegate.apiKey, @"textField", nil]];
		apiToken = cell.textField;
	}

    return cell;
}

/*
 To conform to Human Interface Guildelines, since selecting a row would have no effect (such as navigation), make sure that rows cannot be selected.
 */
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (IBAction)sendHelpEmailAction:(id)sender
{
	NSString *url = @"mailto:support@appremix.com?subject=PackLog%20Help";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)getTokenAction:(id)sender
{
	NSLog(@"getTokenAction");
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Find your Backpack token" message:@"E-mail yourself the link provided in the next screen.\n\nThen, follow the link from your desktop computer.  Instructions for finding your Backpack API token and an easy way to e-mail it to yourself await!"
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	NSLog(@"getTokenAction dismissed.  Sending to Mail.");
	NSString *url = @"mailto:?subject=Follow%20this%20link%20from%20your%20desktop%20computer&body=http%3A%2F%2Fappremix.com%2Fpacklog%2Fsetup.php";
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (IBAction)saveAction:(id)sender
{
	NSLog(@"Subdomain may be %@ and API token is %@", subdomain.text, apiToken.text);

	if ([subdomain.text isEqualToString:@""] || [apiToken.text isEqualToString:@""] || subdomain.text == nil || apiToken.text == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"All fields are required" message:@"Need help?  E-mail support@appremix.com"
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];
	} else {
		PackLogAppDelegate *appDelegate = (PackLogAppDelegate *)[[UIApplication sharedApplication] delegate];

		[appDelegate saveSubdomain:subdomain.text];
		[appDelegate saveApiKey:apiToken.text];

		[self dismissModalViewControllerAnimated:YES];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	return YES;
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"%@ viewDidAppear", self);
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
	NSLog(@"%@ didReceiveMemoryWarning", self);
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	NSLog(@"%@ dealloc", self);
    [super dealloc];
}


@end

