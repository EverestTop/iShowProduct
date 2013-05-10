//
//  Customer.m
//  iFurniture
//
//  Created by shanwenyu on 11-7-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Customer.h"
#import "Item.h"


@implementation Customer
@dynamic age;
@dynamic phone;
@dynamic gender;
@dynamic name;
@dynamic firstComeTime;
@dynamic items;

- (void)addItemsObject:(Item *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"items"] addObject:value];
    [self didChangeValueForKey:@"items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeItemsObject:(Item *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"items"] removeObject:value];
    [self didChangeValueForKey:@"items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addItems:(NSSet *)value {    
    [self willChangeValueForKey:@"items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"items"] unionSet:value];
    [self didChangeValueForKey:@"items" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeItems:(NSSet *)value {
    [self willChangeValueForKey:@"items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"items"] minusSet:value];
    [self didChangeValueForKey:@"items" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
