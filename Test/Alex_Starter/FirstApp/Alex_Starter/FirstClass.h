//
//  FirstClass.h
//  Alex_Starter
//
//  Created by Alex on 13-4-6.
//
//

#import <Foundation/Foundation.h>

@interface FirstClass : NSObject
{
    int counter;
}

- (void) setCounter:(int) newCounter;
- (int) getCounter;
- (void) printCounter;

@end
