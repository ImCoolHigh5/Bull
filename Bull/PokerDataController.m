//
//  PokerDataController.m
//  Bull
//
//  Created by Jason Welch on 5/28/14.
//  Copyright (c) 2014 Stevenson University. All rights reserved.
//

#import "PokerDataController.h"
#import "Hand.h"
#import "Card.h"

@interface PokerDataController ()

@property (nonatomic, strong) NSArray *pokerHand;
@property (nonatomic) int lowestValue;
@property (nonatomic) int highestValue;
@property (nonatomic) BOOL flush;
@property (nonatomic) int count;
@property (nonatomic, strong) NSMutableArray *matchValues;

@end


@implementation PokerDataController

#pragma mark - Public Method
// the passed Hand object is returned with the NSString pokerValue and 
// integer values for mainCardValue, secondPairValue, and highCardValue (if applicable)
- (Hand*)setPokerValuesForHand:(Hand*)hand {
	
	matchValues = [[NSMutableArray alloc] init];
	pokerHand = [[NSArray alloc] init];;

#warning the method for makeHandArrayWithHand has not yet been made	
//	self.pokerHand = [self makeHandArrayWithHand:hand];
	self.lowestValue = hand.card1.value;
	self.highestValue = self.lowestValue;
	count = [pokerHand count]; // Just in case it isn't always 5 card stud
	// Compare card values in the hand
	[self findMatches];
	// The type of hand is determined and an NSString is returned
	hand.pokerValue = [self setHandType];
	// No matches means it must be a straight or a flush, meaning no extra high card
	if (!matchValues) {
		hand.mainCardValue = highestValue;
	}
	// Match values are assigned and the remaining high card determined
	else {
		hand = [self handleMatchesForPokerHand:hand];
		hand.highCardValue = [self setHighCardForHand:hand];
	}
	// The Hand object returned with properties now set
	return hand;
}

#pragma mark - Helper Methods
// Each card in the hand is compared to all proceeding cards for possible matches
- (void)findMatches {

	for(int x = 0; x < count; x++) {
		for (int y = x + 1; y < count; y++) {
			
			int val1 = pokerHand[x].value;
			int val2 = pokerHand[y].value;
			
			// To avoid excessive iteration, suits are compared for a flush during the search for matching values
			// As long as the suits match, flush = YES
			if (![pokerHand.suit isEqualToString: pokerHand[y].suit) {
				flush = NO;
			}
			// The amount of matched values in the array will show the type of hand
			if (val2 == val 1) {
				[matchValues addObject:pokerHand[x].value];
			}
		}
		// Checking if this is the lowest or highest card encountered so far
		if (pokerHand[x].value < lowestValue) {
			lowestValue = pokerHand[x].value;
		}
		if (pokerHand[x].value < highestValue) {
			 highestValue = pokerHand[x].value;
		}
	}
}
// Returns a string that represents the poker hand  				  
- (NSString*)setHandType {
#warning defines might be necessary to keep the coded strings straight					  
	// flush is true if compared cards never had different suits
	// flush is testing twice in case of a Straight Flush
	if ([self isStraight]) {
		if (flush) {
			return @"SF";
		} else {
			return @"ST";
		}
	}
	if (flush) {
		return @"FL";
	}
	// After findMatches is run, the amount of values in the array can predict the type 				  
	switch [matchValues count] {
						  
		case 6:
		case 5: return @"4K";
		case 4: return @"FH";
		case 3: return @"3K";
		case 2: return @"2P";
		case 1: return @"1P";
		default: return @"HC";
	}
}
// Determines whether or not the hand contains a straight
// this method is further moduler to simplify the aceAlternative method	
- (BOOL)isStraight {
					  
	int nextValue = lowestValue + 1;
	// Checks both potential values of an Ace (int value of 14)				  
	if (highestValue == 14) {
		if ([self aceAlternative]) {
			return YES;
		}
	}
	// straightCheckWithNextValue is YES values are in sequence 		  
	return [self straightCheckWithNextValue: nextValue];
}
// Functions as a separate conditional, assuming an Ace has a value of 1				  
- (BOOL)aceAlternative {
	
	if ([self straightCheckWithNextValue:2]) {
		// Assigning the Ace as a 1 shifts the low and high cards
		lowestValue = 1;
		highestValue = 5;
		return YES;
	}
	// NO, there is not a straight with an Ace valued at 1			  
	return NO;
}
				  
- (BOOL)straightCheckWithNextValue:(int)nextValue {
	// The amount of cards in the hand determines the amount of times each card is checked for a sequential value				  
	for (int x = 0; x < count; x++) {
		for (int y = 0; y < count; y++) {
			// Is this card the next in the sequence?
			if (pokerHand[y].value == nextValue) {
				nextValue++;
				break;
			}
			// Made it through every card in the hand without a match? No sense in continuing
			if (y == count) {
				return NO;
			}
		}
		// The the last in sequence would be lowestValue + 4, but this accounts for the preceding nextValue++
		if (nextValue == lowestValue + 5) {
			return YES;
		}
	}
	// Default result
	return NO;
}
// Sets values for mainCardValue and secondPairValue (if 2 Pair of Full House)			  
- (Hand*)handleMatchesForPokerHand:(Hand*)hand {
	// Assumes pokerValue has already been set				  
	NSString *type = [[NSString alloc] initWithString:hand.pokerValue];
	// Creating a starting value to work with, witholds in the case of 1P, 3K, or 4K
	hand.mainCardValue = matchValues[0];
	// Determines the secondPairValue				  
	if (type == @"FH" || type == @"2P") {
		for (int value in matchValues) {
			if (hand.mainCardValue < value) {
				hand.secondPairValue = hand.mainCardValue;
				hand.mainCardValue = value;
				break;
			}
			if (hand.mainCardValue > value) {
				hand.secondPairValue = value;
				break;
			}
		}
	}
	return hand;
}
// Determines what the highest value is when the values in matchValues are ignored				  
- (int)setHighCardForHand:(Hand*)hand {
					  
	NSString *handType = [[NSString alloc] initWithString:hand.pokerValue];
	// Simple matters first				  
	if (handType == @"HC") {
		return hand.mainValue;
	}
					  
	int highCardValue = 0;
	// Checks each card in the hand against each value in matchValues				  
	for (int i = 0; i < count; i++) {
		for (int value in matchValues) {
			if (value != pokerHand[i].value) {
				if (value > highCardValue) {
					highCardValue = value;
				}
			}
		}
	}
	return highCardValue;
}
				  
@end
