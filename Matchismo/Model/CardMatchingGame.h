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
-(void)selectType:(NSUInteger)index;

-(void)chooseCardAtIndex:(NSUInteger) index;
-(Card *)cardAtIndex:(NSUInteger) index;

@property (nonatomic, readonly) NSInteger score;
//선택된 카드. one two sam 순서대로 저장된다.
@property (nonatomic, readwrite) NSString *cardOne;
@property (nonatomic, readwrite) NSString *cardTwo;
@property (nonatomic, readwrite) NSString *cardSam;
//지정된 게임 2개짜리 3개짜리 선택 여부를 저장한다.
@property (nonatomic, readwrite) NSInteger selectedMatch;
//게임 상태 저장. 1은 새로 시작, 2는 일치. 3은 일치 안함, 4는 하나만 선택
@property (nonatomic, readwrite) NSInteger matchState;
@end
