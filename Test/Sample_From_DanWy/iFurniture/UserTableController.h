//
//  UserTableController.h
//  iFurniture
//
//  Created by shanwenyu on 11-6-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserTableController : UIViewController {
    NSMutableArray *customersArray;
    UITableView * customerTableView;
}

@property (nonatomic, retain) NSMutableArray *customersArray;
@property (nonatomic, retain) IBOutlet UITableView * customerTableView;



- (IBAction)createNewCustomer:(id)sender;

@end
