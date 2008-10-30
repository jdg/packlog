//
//  EntryCell.h
//  PackLog
//
//  Created by Jonathan George on 10/9/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EntryCell : UITableViewCell {
	IBOutlet UILabel *name;
	IBOutlet UILabel *date;
	IBOutlet UILabel *entry;
}

@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *entry;

- (void)setData:(NSMutableDictionary *)entryDict messageKey:(NSString *)messageKey;
- (NSString *)formattedDate:(NSString *)dateToFormat;

@end
