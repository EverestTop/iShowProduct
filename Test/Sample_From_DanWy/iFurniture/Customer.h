//
//  Customer.h
//  iFurniture
//
//  Created by shanwenyu on 11-7-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Customer : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * firstComeTime;
@property (nonatomic, retain) NSSet* items;

@end
