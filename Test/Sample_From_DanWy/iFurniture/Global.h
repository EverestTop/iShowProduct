//
//  Global.h
//  iFurniture
//
//  Created by Dan on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Customer.h"

@interface Global : NSObject {
}

+(Global *)sharedInstance;

@property (nonatomic, retain) Customer * currentCustomer;


@end
