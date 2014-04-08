//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by apple06 on 2014. 3. 25..
//  Copyright (c) 2014년 COMP420. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;//of card
@end
//ch기화 할때 초기할때 상위 클래스의  inti를 불러준다.
@implementation CardMatchingGame

-(NSMutableArray *)cards
{
    if(!_cards)_cards = [[NSMutableArray alloc] init];
    return _cards;
}
//지정 초기화
-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck;
{
    self.cardOne = nil;
    self.cardTwo = nil;
    self.matchState = 1;
    self = [super init];
    if(self)
    {
        for (int i =0 ; i<count ; i++){
            Card *card = [deck drawRandomCard];
            if(card)
            {
                [self.cards addObject:card];
            }
            else
            {
                self = nil;
                break;
            }
        }
        
    }
    return self;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count])?self.cards[index]:nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

//state 설명
//1 : 완전 새로 시작하는 경우
//2 : 서로 일치하는 경우
//3 : 일치 하지 않는 경우
//4 : 하나만 선택된 경우

-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if(!card.isMatched)
    {
        if(card.isChosen)
        {
            card.chosen = NO;
            
        }
        else{
            for(Card *otherCard in self.cards)
            {
                if(otherCard.isChosen && !otherCard.isMatched)
                {
                    int matchScore = [card match:@[otherCard]];
                    if(matchScore)
                    {
                        self.score += matchScore * MATCH_BONUS;
                        otherCard.matched = YES;
                        card.matched = YES;
                        self.cardOne = otherCard.contents;
                        self.cardTwo = card.contents;
                        self.matchState = 2;
                        //일치된 경우 각 카드의 컨텐츠를 저장하고 일치된 state로 바꾼다.
                        //일치의 경우 지정된 보너스를 받는다
                    }
                    else{
                        self.score-= MISMATCH_PENALTY;
                        otherCard.chosen = NO;
                        self.cardOne = otherCard.contents;
                        self.cardTwo = card.contents;
                        self.matchState = 3;
                        //불일치 되는 경우 패널티를 받는다.
                        //불일치된 카드를 저장하고 불일치된 state로 바꾼다.
                    }
                    break;
                }
                else
                {
                    self.cardTwo = card.contents;
                    self.matchState = 4;
                    //하나만 선택된 상태
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
            //선택시 점수를 깎을 수 있다.
        }
    }
}
@end
