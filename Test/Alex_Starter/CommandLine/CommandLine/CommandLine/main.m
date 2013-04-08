//
//  main.m
//  CommandLine
//
//  Created by Alex on 13-4-6.
//  Copyright (c) 2013年 EverestTop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Greeter.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        Greeter* myGreeter = [[Greeter alloc] init];
        
        [myGreeter setGreetingText: @"Fuck you, again and again!"];
        [myGreeter printGreeting];
        [myGreeter release];
        
    }
    return 0;
}

