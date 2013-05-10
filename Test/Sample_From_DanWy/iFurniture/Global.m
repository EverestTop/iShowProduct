//
//  Global.m
//  iFurniture
//
//  Created by Dan on 11-7-21.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Global.h"


@implementation Global
@synthesize currentCustomer;


static Global *instance = nil;

+(Global *)sharedInstance
{
    if (instance == nil) {
        instance = [[self alloc] init];
    }
    return instance;
}

@end
