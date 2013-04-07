//
//  Greeter.h
//  CommandLine
//
//  Created by Alex on 13-4-7.
//  Copyright (c) 2013年 EverestTop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Greeter : NSObject
{
    NSString *greetingText;
}

- (NSString*) getGreetingText;
- (void) setGreetingText: (NSString*) newText;
- (void) printGreeting;

@end
