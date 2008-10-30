//
//  EditableCell.h
//  PackLog
//
//  Created by Jonathan George on 10/10/08.
//  Copyright 2008 JDG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EditableCell : UITableViewCell {
	IBOutlet UILabel *title;
	IBOutlet UITextField *textField;
	
	CGRect *textFieldRect;
}

-(void) setData:(NSMutableDictionary *)dict;

@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UITextField *textField;

@end
