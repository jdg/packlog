//
//  JournalController.h
//  PackLog
//
//  Created by Jonathan George on 10/9/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JournalManager.h"
#import "EntryCell.h"

@interface JournalController : UIViewController < UITextFieldDelegate > {
	IBOutlet UITextField *currently;
	IBOutlet UITableView *tableView;
	IBOutlet UINavigationBar *navigationBar;
	IBOutlet UINavigationItem *navigationItem;

	IBOutlet EntryCell *entryCell;

	JournalManager *manager;
}

@property (nonatomic, retain) IBOutlet UITextField *currently;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *navigationItem;
@property (nonatomic, retain) IBOutlet EntryCell *entryCell;

- (IBAction)updateJournal:(id)sender;
- (IBAction)touchCancel:(id)sender;
- (void)refreshJournalEntries:(id)sender;

- (void)displayCancelButton;
- (void)displayRefreshButton;
- (void)displaySettingsButton;

- (void)checkSettings;

@end
