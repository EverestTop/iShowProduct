//
//  NewUserInputController.m
//  iFurniture
//
//  Created by Dan on 11-6-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NewUserInputController.h"
#import "Customer.h"
#import "iFurnitureAppDelegate.h"
#import "Global.h"

@implementation NewUserInputController

@synthesize newCustomerTable;
//@synthesize cancelButton;
//@synthesize finishButton;
@synthesize pickerView, dateFormatter;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userTableController:(UserTableController *)controller
{
    userTableController = controller;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [newCustomerTable release];
    [cancelButton release];
    [finishButton release];

	[dataSourceArray release];
    
    [pickerView release];
	[dateFormatter release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)cancleNewCustomer:(id)sender {
    [self dismissModalViewControllerAnimated: YES];
}

- (IBAction)doneNewCustomer:(id)sender {

    NSManagedObjectContext * context = [(iFurnitureAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    Customer *customer = (Customer *)[NSEntityDescription insertNewObjectForEntityForName:@"Customer" inManagedObjectContext:context];
    [customer setFirstComeTime:[NSDate date]];
    [customer setName:textFieldName.text];
    [customer setPhone:textFieldPhone.text];
    [Global sharedInstance].currentCustomer = customer;
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        // Handle the error.
        NSLog(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXX");        
    }
    
    [self dismissModalViewControllerAnimated: YES];
    [userTableController viewDidLoad];
    [userTableController.customerTableView reloadData];
}


#define kTextFieldWidth	260.0

#define kLeftMargin				120.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kTweenMargin			10.0

#define kTextFieldHeight		30.0

static NSString *kSectionTitleKey = @"sectionTitleKey";
static NSString *kSourceKey = @"sourceKey";
static NSString *kViewKey = @"viewKey";

const NSInteger kViewTag = 1;

//@synthesize textFieldNormal, textFieldRounded, textFieldSecure, textFieldLeftView, dataSourceArray;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
	//datePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
	
	// note we are using CGRectZero for the dimensions of our picker view,
	// this is because picker views have a built in optimum size,
	// you just need to set the correct origin in your view.
	//
	// position the picker at the bottom
    CGRect parentRect = self.view.frame;
	
    datePickerView.frame = CGRectMake(parentRect.size.width / 2, 100, 320, 600);	
	// add this picker to our view controller, initially hidden
    datePickerView.hidden = YES;    
	[self.view addSubview:datePickerView];
    
    textFieldName = [self textFieldRimless];
    textFieldName.placeholder = @"在此输入一个称呼";
    
    textFieldPhone = [self textFieldRimless];
    textFieldPhone.placeholder = @"输入电话号码";
    	
	self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	self.title = NSLocalizedString(@"TextFieldTitle", @"");
	
	// we aren't editing any fields yet, it will be in edit when the user touches an edit field
	self.editing = NO;
}

// called after the view controller's view is released and set to nil.
// For example, a memory warning which causes the view to be purged. Not invoked as a result of -dealloc.
// So release any properties that are loaded in viewDidLoad or can be recreated lazily.
//
- (void)viewDidUnload
{
	[super viewDidUnload];
	
	// release the controls and set them nil in case they were ever created
	// note: we can't use "self.xxx = nil" since they are read only properties
	//
    
    [self setNewCustomerTable:nil];
	dataSourceArray = nil;
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kCustomCellID = @"CustomCellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCustomCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCustomCellID] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
    NSUInteger row = [indexPath row];
    
    switch (row) {
        case 0:
            cell.textLabel.text = @"初次到访时间";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:[NSDate date]];
            break;
        case 1:
            cell.textLabel.text = @"称呼";
            [cell.contentView addSubview:textFieldName];
            break;
        case 2:
            cell.textLabel.text = @"电话";
            [cell.contentView addSubview:textFieldPhone];
            break;
        default:
            break;
    }
    
	return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath %d", indexPath.row);

    NSUInteger row = [indexPath row];
    switch (row) {
        case 0:
            datePickerView.hidden = NO;
            break;
        case 1:
            datePickerView.hidden = YES;
            break;
        case 2:
            datePickerView.hidden = YES;
            break;
        default:
            break;
    }

	UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
	self.pickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];

}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// the user pressed the "Done" button, so dismiss the keyboard
	[textField resignFirstResponder];
	return YES;
}


#pragma mark -
#pragma mark Text Fields


- (UITextField *)textFieldRimless
{

    CGRect frame = CGRectMake(kLeftMargin, 8.0, kTextFieldWidth, kTextFieldHeight);
    UITextField *textFieldRimless = [[UITextField alloc] initWithFrame:frame];
    
    textFieldRimless.borderStyle = UITextBorderStyleNone;
    textFieldRimless.textColor = [UIColor blackColor];
    textFieldRimless.font = [UIFont systemFontOfSize:18.0];
    //		textFieldRimless.placeholder = @"<enter text>";
    textFieldRimless.backgroundColor = [UIColor clearColor];
    textFieldRimless.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
    
    textFieldRimless.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
    textFieldRimless.returnKeyType = UIReturnKeyDone;
    
    textFieldRimless.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
    
    textFieldRimless.tag = kViewTag;		// tag this control so we can remove it later for recycled cells
    //		
    //		textFieldRimless.delegate = self;	// let us be the delegate so we know when the keyboard's "Done" button is pressed
    
    // Add an accessibility label that describes what the text field is for.
    [textFieldRimless setAccessibilityLabel:NSLocalizedString(@"NormalTextField", @"")];

	return [textFieldRimless autorelease];
}


@end
