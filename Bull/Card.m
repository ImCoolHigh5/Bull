//
//  Card.m
//  Bull
//
//  Created by Jason Welch on 5/28/14.
//  Copyright (c) 2014 Stevenson University. All rights reserved.
//

#import "Card.h"

@implementation Card

// Intialize card with passed values
-(id)initCardWithSuite:(NSString*)suit andValue:(NSNumber*)value
{
    if (self == [super init]) {
        self.suit  = suit;
        self.value = value;
    }
    
    return self;
    
}

// Return a string representing the name of the image file
- (NSString *)cardImageName
{
    return [NSString stringWithFormat:@"%@-%@", self.suit, self.value];
}


@end
