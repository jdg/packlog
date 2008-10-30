//
//  EntryCell.m
//  PackLog
//
//  Created by Jonathan George on 10/9/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import "EntryCell.h"


@implementation EntryCell

@synthesize name, date, entry;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialization code
	}
    return self;
}

- (void)setData:(NSMutableDictionary *)entryDict messageKey:(NSString *)messageKey {
	self.name.text = [entryDict objectForKey:@"user_name"];
	self.date.text = [self formattedDate:[entryDict objectForKey:@"updated-at"]];
	self.entry.text = [entryDict objectForKey:messageKey];

	self.entry.lineBreakMode = UILineBreakModeWordWrap;
	self.entry.numberOfLines = 0;
	self.name.font = [UIFont boldSystemFontOfSize:17.0];
}

- (NSString *)formattedDate:(NSString *)dateToFormat
{
	NSDate *posted_at = [NSDate dateWithNaturalLanguageString:dateToFormat];

	NSTimeInterval distance_in_seconds = [posted_at timeIntervalSinceNow] * -1;
	NSTimeInterval distance_in_minutes = distance_in_seconds / 60;

//	NSLog(@"minutes: %f - seconds: %f", distance_in_minutes, distance_in_seconds);

	if (distance_in_minutes < 2) {
		return @"<1 minute";
	} else if (distance_in_minutes >= 2 && distance_in_minutes <= 44) {
		return [NSString stringWithFormat:@"%1.0f minutes", round(distance_in_minutes)];
	} else if (distance_in_minutes >= 45 && distance_in_minutes <= 89) {
		return @"1 hour";
	} else if (distance_in_minutes >= 90 && distance_in_minutes <= 1439) {
		return [NSString stringWithFormat:@"%1.0f hours", round(distance_in_minutes / 60)];
	} else if (distance_in_minutes >= 1440 && distance_in_minutes <= 2879) {
		return @"1 day";
	} else if (distance_in_minutes >= 2880 && distance_in_minutes <= 43199) {
		return [NSString stringWithFormat:@"%1.0f days", round(distance_in_minutes / 1440)];
	}

	return @"awhile ago";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	NSLog(@"%@ dealloc", self);
    [super dealloc];
}


@end
