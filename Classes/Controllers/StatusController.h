//
//  StatusController.h
//  PackLog
//
//  Created by Jonathan George on 10/10/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StatusManager.h"
#import "EntryCell.h"

@interface StatusController : UIViewController < UITextFieldDelegate > {
	IBOutlet UITextField *statusEntry;
	IBOutlet UITableView *statusTableView;

	IBOutlet EntryCell *entryCell;
	
	StatusManager *manager;
}

@property (nonatomic, retain) IBOutlet UITextField *statusEntry;
@property (nonatomic, retain) IBOutlet UITableView *statusTableView;
@property (nonatomic, retain) IBOutlet EntryCell *entryCell;

- (IBAction)updateJournal:(id)sender;
- (IBAction)touchCancel:(id)sender;
- (void)refreshJournalEntries:(id)sender;

- (void)displayCancelButton;
- (void)displayRefreshButton;

@end
