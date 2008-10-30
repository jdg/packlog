//
//  UserManager.h
//  PackLog
//
//  Created by Jonathan George on 10/13/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TouchXML.h"

@interface UserManager : NSObject {
	NSMutableArray *userEntries;
	NSMutableData *receivedData;
}

@property (nonatomic, retain) NSMutableArray *userEntries;

- (void) fetch;
- (void) convertXMLDocumentToEntries:(CXMLDocument *)xml;

@end
