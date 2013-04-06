//
//  Item.h
//  iFurniture
//
//  Created by shanwenyu on 11-8-2.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Item : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * price;
@property (nonatomic, retain) NSString * imagePath;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * length;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * type;

@end
