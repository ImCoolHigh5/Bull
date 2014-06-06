//
//  Hand.m
//  Bull
//
//  Created by Jason Welch on 5/28/14.
//  Copyright (c) 2014 Stevenson University. All rights reserved.
//

#import "Hand.h"

@implementation Hand

- (int)valueOfCardAtIndex:(int)cardIndex {
	
	Card *cardAtIndex = [[Card alloc] init];
	
	cardAtIndex = self.cards[cardIndex];
	
	return [cardAtIndex.value intValue];
}

@end
