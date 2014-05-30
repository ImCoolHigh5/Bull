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

- (Hand*)setPokerValuesForHand:(Hand*)hand {
	
	NSMutableArray *matchValues = [[NSMutableArray alloc] init];
	NSArray *pokerHand = [[NSArray alloc] init];;
	
//	self.pokerHand = [self makeHandArrayWithHand:hand];
	self.lowestValue = hand.card1.value;
	self.highestValue = self.lowestValue;
	int count = [pokerHand count];
	
	for(int x = 0; x < count; x++) {
		for (int y = x + 1; y < count; y++) {
			
			int val1 = pokerHand[x].value;
			int val2 = pokerHand[y].value;
			
			if (![pokerHand.suit isEqualToString: pokerHand[y].suit) {
				flush = NO;
			}
				  if (val2 == val 1) {
					  [matchValues addObject:pokerHand[x].value];
				  }
				  }
				  if (pokerHand[x].value < lowestValue) {
					  lowestValue = pokerHand[x].value;
				  }
				  if (pokerHand[x].value < highestValue) {
					  highestValue = pokerHand[x].value;
				  }
				  }
				  
				  hand.pokerValue = [self setHandType];
				  
				  if (!matchValues) {
					  hand.mainCardValue = highestValue;
				  }
				  else {
					  hand = [self handleMatchesForPokerHand:hand];
					  hand.highCardValue = [self setHighCardForHand:hand];
				  }
				  
				  return hand;
				  }
				  
				  - (NSString*)setHandType {
					  
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
				  
				  - (BOOL)isStraight {
					  
					  int nextValue = lowestValue + 1;
					  
					  if (highestValue == 14) {
						  if ([self aceAlternative]) {
							  return YES;
						  }
					  }
					  
					  return [self straightCheckWithNextValue: nextValue];
				  }
				  
				  - (BOOL)aceAlternative {
					  
					  if ([self straightCheckWithNextValue:2]) {
						  lowestValue = 1;
						  highestValue = 5;
						  return YES;
					  }
					  
					  return NO;
				  }
				  
				  - (BOOL)straightCheckWithNextValue:(int)nextValue {
					  
					  for (int x = 0; x < count; x++) {
						  for (int y = 0; y < count; y++) {
							  if (pokerHand[y].value == nextValue) {
								  nextValue++;
								  break;
							  }
							  if (y == count) {
								  return NO;
							  }
						  }
						  if (nextValue == lowestValue + 5) {
							  return YES;
						  }
					  }
					  return NO;
				  }
				  
				  - (Hand*)handleMatchesForPokerHand:(Hand*)hand {
					  
					  NSString *type = [[NSString alloc] initWithString:hand.pokerValue];
					  hand.mainCardValue = matchValues[0];
					  
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
				  
				  - (int)setHighCardForHand:(Hand*)hand {
					  
					  NSString *handType = [[NSString alloc] initWithString:hand.pokerValue];
					  
					  if (handType == @"HC") {
						  return hand.mainValue;
					  }
					  
					  int highCardValue= 0;
					  
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
