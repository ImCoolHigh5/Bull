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
	
	_matchValues = [[NSMutableArray alloc] init];
	_pokerHand = [[NSArray alloc] init];;

#warning the method for makeHandArrayWithHand has not yet been made	     
	
	self.pokerHand = [NSArray arrayWithArray:hand.cards];
	self.lowestValue = [hand valueOfCardAtIndex:0];
	self.highestValue = self.lowestValue;
	self.count = [_pokerHand count]; // Just in case it isn't always 5 card stud
	
	// Compare card values in the hand
	[self findMatches];
	
	// The type of hand is determined and an NSString is returned
	hand.pokerValue = [self setHandType];
	
	// No matches means it must be a straight or a flush, meaning no extra high card
	if (!self.matchValues) {
		hand.mainCardValue = _highestValue;
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

	for(int x = 0; x < _count; x++) {
		
		Card *thisCard = [[Card alloc] init];
		thisCard = _pokerHand[x];
		int val1 = [thisCard.value intValue];
		
		for (int y = x + 1; y < _count; y++) {
			
			// To get around the issue of dot notations with array indexing
			Card *thatCard = [[Card alloc] init];
			
			
			thatCard = _pokerHand[y];
			
			int val2 = [thatCard.value intValue];
			
			// To avoid excessive iteration, suits are compared for a flush during the search for matching values
			// As long as the suits match, flush = YES
			if (![thisCard.suit isEqualToString: thatCard.suit]) {
				_flush = NO;
			}
				  
			// The amount of matched values in the array will show the type of hand
			if (val2 == val1) {
				[_matchValues addObject:thisCard.value];
			}
		}
				  
		// Checking if this is the lowest or highest card encountered so far
		if (val1 < _lowestValue) {
			_lowestValue = val1;
		}
				  
		if (val1 < _highestValue) {
			 _highestValue = val1;
		}
	}
}
	
				  
// Returns a string that represents the poker hand  				  
- (NSString*)setHandType {
	
#warning defines might be necessary to keep the coded strings straight					  
	
	// flush is true if compared cards never had different suits
	// flush is testing twice in case of a Straight Flush
	if ([self isStraight]) {
		if (_flush) {
			return @"SF";
		} else {
			return @"ST";
		}
	}
	
	if (_flush) {
		return @"FL";
	}
	
	// After findMatches is run, the amount of values in the array can predict the type 				  
	switch ([_matchValues count]) {
						  
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
					  
	int nextValue = _lowestValue + 1;
	
	// Checks both potential values of an Ace (int value of 14)
	if (_highestValue == 14) {
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
		_lowestValue = 1;
		_highestValue = 5;
		return YES;
	}
	
	// NO, there is not a straight with an Ace valued at 1			  
	return NO;
}
	
				  
- (BOOL)straightCheckWithNextValue:(int)nextValue {
	
	// The amount of cards in the hand determines the amount of times each card is checked for a sequential value
	for (int x = 0; x < _count; x++) {
		for (int y = 0; y < _count; y++) {
			
			
			Card *thisCard = [[Card alloc] init];
			thisCard = _pokerHand[y];
			int val1 = [thisCard.value intValue];
			
			// Is this card the next in the sequence?
			if (val1 == nextValue) {
				nextValue++;
				break;
			}
			
			// Made it through every card in the hand without a match? No sense in continuing
			if (y == _count) {
				return NO;
			}
		}
		
		// The the last in sequence would be lowestValue + 4, but this accounts for the preceding nextValue++
		if (nextValue == _lowestValue + 5) {
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
	hand.mainCardValue = [_matchValues[0] intValue];
	
	// Determines the secondPairValue
	if ([type  isEqual: @"FH"] || [type  isEqual: @"2P"]) {
		for (NSNumber *value in _matchValues) {
			if (hand.mainCardValue < [value intValue]) {
				hand.secondPairValue = hand.mainCardValue;
				hand.mainCardValue = [value intValue];
				break;
			}
			if (hand.mainCardValue > [value intValue]) {
				hand.secondPairValue = [value intValue];
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
	if ([handType  isEqual: @"HC"]) {
		return hand.mainCardValue;
	}
					  
	int highCardValue = 0;
	
	// Checks each card in the hand against each value in matchValues
	for (int i = 0; i < _count; i++) {
		for (NSNumber *value in _matchValues) {
			
			Card *thisCard = [[Card alloc] init];
			thisCard = _pokerHand[i];
			int val1 = [thisCard.value intValue];
			
			if ([value intValue] != val1) {
				if ([value intValue] > highCardValue) {
					highCardValue = [value intValue];
				}
			}
		}
	}
	
	return highCardValue;
}
				  
@end
