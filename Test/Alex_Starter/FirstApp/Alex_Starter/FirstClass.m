//
//  FirstClass.m
//  Alex_Starter
//
//  Created by Alex on 13-4-6.
//
//

#import "FirstClass.h"

@implementation FirstClass
- (id)init
{
    counter = 0;
}

- (void) setCounter:(int)newcounter
{
    counter = newcounter;
    return;
}

- (int) getCounter
{
    return counter;
}

- (void) printCounter
{
    printf("The value of counter is %d.\n", counter);
    return;
}

@end
