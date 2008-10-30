//
//  StatusEntryModel.h
//  PackLog
//
//  Created by Jonathan George on 10/29/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLitePersistentObject.h"

@interface StatusEntryModel : SQLitePersistentObject {
	NSString *statusEntryId;
	NSString *message;
	NSString *username;
	NSString *updatedAt;
}

@property (nonatomic, retain) NSString *statusEntryId;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *updatedAt;

@end
