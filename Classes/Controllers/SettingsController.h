//
//  SettingsController.h
//  PackLog
//
//  Created by Jonathan George on 10/10/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditableCell.h"

@interface SettingsController : UIViewController < UITextFieldDelegate > {
	IBOutlet EditableCell *editableCell;

	IBOutlet UIButton *saveButton;
	IBOutlet UIButton *getTokenButton;

	NSMutableDictionary *entryCells;

	UITextField *subdomain;
	UITextField *apiToken;

	IBOutlet UITableView *tableView;
}

@property (nonatomic, retain) IBOutlet EditableCell *editableCell;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *getTokenButton;

- (IBAction)getTokenAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)sendHelpEmailAction:(id)sender;

@end
