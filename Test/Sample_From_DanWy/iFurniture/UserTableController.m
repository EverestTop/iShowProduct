//
//  UserTableController.m
//  iFurniture
//
//  Created by shanwenyu on 11-6-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UserTableController.h"
#import "NewUserInputController.h"
#import "iFurnitureAppDelegate.h"
#import "Customer.h"
#import "Global.h"
#import "Item.h"
#import "PhotoViewController.h"

@implementation UserTableController

@synthesize customersArray, customerTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSManagedObjectContext * context = [(iFurnitureAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error = nil;
    
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults == nil) {
        
        // Handle the error.
        
    }
    
    NSLog(@"%@", mutableFetchResults);
    
    [self setCustomersArray:mutableFetchResults];
    [mutableFetchResults release];
    [request release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [customerTableView setEditing:editing animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
    return [customersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
	// A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
	
	static NSNumberFormatter *numberFormatter = nil;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Get the event corresponding to the current index path and configure the table view cell.
	Customer *customer = (Customer *)[customersArray objectAtIndex:indexPath.row];

    NSString *string = [NSString stringWithFormat:@"%@, 电话: %@, 初次到访时间: %@, 关注商品数量: %d", 
                        [customer name], [customer phone], [dateFormatter stringFromDate:[customer firstComeTime]], [customer.items count]];
	cell.textLabel.text = string;
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSLog(@"delete idnex %d", indexPath.row);

        
        // Delete the managed object at the given index path.
		NSManagedObject *customerToDelete = [customersArray objectAtIndex:indexPath.row];
        NSManagedObjectContext * managedObjectContext = [(iFurnitureAppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];

		[managedObjectContext deleteObject:customerToDelete];
		
		// Update the array and table view.
        [customersArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		// Commit the change.
		NSError *error;
		if (![managedObjectContext save:&error]) {
			// Handle the error.
		}
    }   
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    Customer *customer = (Customer *)[customersArray objectAtIndex:indexPath.row];
    NSLog(@"accessoryButtonTappedForRowWithIndexPath index: %d, customer: %@", indexPath.row, customer.name);
    NSString * msg = @"";
    for (Item *item in customer.items) {
        NSLog(@"image path: %@", item.imagePath);
        msg = [msg stringByAppendingFormat:@"%@ \n", [item.imagePath substringFromIndex:76]];
	}
    
    if ([customer.items count] == 0) {
        // open an alert with just an OK button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有关注任何商品" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];	
        [alert release];
    } else {
        NSMutableArray *allImagePaths = [[NSMutableArray alloc] init];
        for (Item *item in customer.items) {        
            [allImagePaths addObject:item.imagePath];
        }
        
        PhotoViewController *targetViewController = [[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil allImagePaths:allImagePaths];
        [self.navigationController pushViewController:targetViewController animated:YES];
        UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消关注", @"")
                                                                          style:UIBarButtonItemStyleBordered
                                                                         target:self
                                                                         action:nil] autorelease];
        targetViewController.navigationItem.rightBarButtonItem = cancelButton;
        [targetViewController release];
        [allImagePaths release];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"UserTable didSelectRowAtIndexPath");
    Customer *customer = (Customer *)[customersArray objectAtIndex:indexPath.row];
    [Global sharedInstance].currentCustomer = customer;
}

- (IBAction)createNewCustomer:(id)sender
{
    NSLog(@"createNewCustomer");
    
    NewUserInputController *controller = [[NewUserInputController alloc] initWithNibName: @"NewUserInputController" bundle: nil userTableController: self];
    
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    controller.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [self presentModalViewController: controller animated: YES];
    [controller release];
}

@end
