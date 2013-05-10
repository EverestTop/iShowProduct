//
//  NewUserInputController.h
//  iFurniture
//
//  Created by Dan on 11-6-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTableController.h"


@interface NewUserInputController : UIViewController <UITableViewDelegate> {
    
    UITableView *newCustomerTable;
    UIBarButtonItem *cancelButton;
    UIBarButtonItem *finishButton;
    
	NSArray			*dataSourceArray;
    
    UserTableController *userTableController;
    UIDatePicker		*datePickerView;
    
    UITextField	*textFieldName;
    UITextField	*textFieldPhone;
 
}

@property (nonatomic, retain) IBOutlet UITableView *newCustomerTable;
@property (nonatomic, retain) IBOutlet UIDatePicker *pickerView; 
@property (nonatomic, retain) NSDateFormatter *dateFormatter; 

- (IBAction)cancleNewCustomer:(id)sender;
- (IBAction)doneNewCustomer:(id)sender;
@end
