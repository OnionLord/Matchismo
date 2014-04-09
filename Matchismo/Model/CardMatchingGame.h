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

//지정된 게임 2개짜리 3개짜리 선택 여부를 저장한다.
@property (nonatomic, readwrite) NSInteger selectedMatch;
//상태바에 나타낼 메시지
@property (nonatomic, readwrite) NSString *matchMessage;
@end
