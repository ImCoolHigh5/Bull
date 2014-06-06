//
//  Hand.h
//  Bull
//
//  Created by Jason Welch on 5/28/14.
//  Copyright (c) 2014 Stevenson University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Hand : NSObject

#pragma mark - IBOutlets


#pragma mark - Public Properties

@property (nonatomic, strong) NSArray *cards;
@property (nonatomic, strong) NSString *pokerValue;
@property (nonatomic) int mainCardValue;
@property (nonatomic) int secondPairValue;
@property (nonatomic) int highCardValue;

#pragma mark - IBActions


#pragma mark - Public Methods

- (int)valueOfCardAtIndex:(int)cardIndex;



@end
