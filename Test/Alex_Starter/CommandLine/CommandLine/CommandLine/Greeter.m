//
//  Greeter.m
//  CommandLine
//
//  Created by Alex on 13-4-7.
//  Copyright (c) 2013年 EverestTop. All rights reserved.
//

#import "Greeter.h"

@implementation Greeter
- (NSString *) getGreetingText
{
    return greetingText;
}

- (void) setGreetingText: (NSString *) newText
{
    [newText retain];
    [greetingText release];
    greetingText = newText;
    return;
}

- (void) printGreeting
{
    NSLog(@"%@", [self greetingText]);
    return;
}

- (void) dealloc
{
    [greetingText release];
    [super dealloc];
    return;
}

@end
