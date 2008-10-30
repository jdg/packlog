//
//  StatusManager.h
//  PackLog
//
//  Created by Jonathan George on 10/10/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TouchXML.h"

@interface StatusManager : NSObject {
	NSMutableArray *statusEntries;
	NSMutableData *receivedData;
}

@property (nonatomic, retain) NSMutableArray *statusEntries;

- (void) fetch;
- (void) convertXMLDocumentToEntries:(CXMLDocument *)xml;
- (void) sendUpdateToJournal:(NSString *)entry;

@end
