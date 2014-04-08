//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by apple06 on 2014. 3. 25..
//  Copyright (c) 2014년 COMP420. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck;

-(void)chooseCardAtIndex:(NSUInteger) index;
-(Card *)cardAtIndex:(NSUInteger) index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readwrite) NSString *cardOne;
@property (nonatomic, readwrite) NSString *cardTwo;
@end
