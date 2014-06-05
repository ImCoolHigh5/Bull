//
//  Card.h
//  Bull
//
//  Created by Jason Welch on 5/28/14.
//  Copyright (c) 2014 Stevenson University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

// Suit stores the suit of the card: Spade, Heart, Club or Diamond
@property (nonatomic, weak) NSString *suit;

// Value stores the rank of the card.
// Face value of card 2 - 10
// Jacks are 11
// Queens are 12
// Kings are 13
// Aces are 14
@property (nonatomic, weak) NSNumber *value;

// Instance method that returns the string for the card PNG image.
// Format examples: diamond-2, heart-king, spade-ace ...
- (NSString*)cardImageName;

@end
