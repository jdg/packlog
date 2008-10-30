//
//  JournalManager.h
//  PackLog
//
//  Created by Jonathan George on 10/9/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TouchXML.h"

@interface JournalManager : NSObject {
	NSMutableArray *journalEntries;
	NSMutableData *receivedData;

	BOOL useSSL;
}

@property (nonatomic, retain) NSMutableArray *journalEntries;

- (void) fetch;
- (void) convertXMLDocumentToEntries:(CXMLDocument *)xml;
- (void) sendUpdateToJournal:(NSString *)entry;

@end
