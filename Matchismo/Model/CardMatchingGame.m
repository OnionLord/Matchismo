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

//Match의 타입을 정한다. index0인 것은 2로 1인 것은 3으로
-(void)selectType:(NSUInteger)index
{
    self.selectedMatch = index + 2;
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count])?self.cards[index]:nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

//state 설명, 현재 게임 상태
//1 : 완전 새로 시작하는 경우
//2 : (2개모드) 서로 일치하는 경우
//3 : (2개모드) 일치 하지 않는 경우
//4 : 하나만 선택된 경우
//5 : (3개모드) 2개만 선택됨
//6 : (3개모드) 모두 선택됨
//7 : (3개모드) 모두 다름


-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    NSMutableArray *currentChosenCards = [[NSMutableArray alloc] init];
    if(!card.isMatched)
    {
        if(card.isChosen)
        {
            card.chosen = NO;
            self.matchState = 1;
            self.cardOne = nil;
            self.cardTwo = nil;
            self.cardSam = nil;
        }
        else{
            if(self.selectedMatch == 2)
            {
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
                            self.cardOne = card.contents;
                            self.cardTwo = otherCard.contents;
                            self.matchState = 2;
                            //일치된 경우 각 카드의 컨텐츠를 저장하고 일치된 state로 바꾼다.
                            //일치의 경우 지정된 보너스를 받는다
                        }
                        else{
                            self.score-= MISMATCH_PENALTY;
                            otherCard.chosen = NO;
                            self.cardOne = card.contents;
                            self.cardTwo = otherCard.contents;
                            self.matchState = 3;
                            //불일치 되는 경우 패널티를 받는다.
                            //불일치된 카드를 저장하고 불일치된 state로 바꾼다.
                        }
                        break;
                    }
                    else
                    {
                        self.cardOne = card.contents;
                        self.cardTwo = nil;
                        self.cardSam = nil;
                        self.matchState = 4;
                        //하나만 선택된 상태
                    }
                }
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
                //선택시 점수를 깎을 수 있다.
            }
            else if(self.selectedMatch == 3)
            {
                
                
                NSMutableArray *Score; //세 가지 짝지어져 비교되는 경우 모두 담아보기
                NSNumber *matchScore; //임시로 스코어 저장
                for(Card *otherCard in self.cards)
                {
                    if(otherCard.isChosen && !otherCard.isMatched)
                    {   //otherCard->이전 카드를 나타냄.
                        //1 -> 2 -> 3 순으로 카드 선택시
                        // 1 - 2
                        // 3 - 1
                        // 3 - 2
                        //순으로 생성. 여기서 생기는 otherCard를 배열에 넣음.
                        [currentChosenCards addObject:otherCard];
                        matchScore = [NSNumber numberWithInt:[card match:@[otherCard]]];//해당 점수를 배열에 넣음

                        if([matchScore intValue])//점수가 있으면, 해당 케이스의 카드가 일치하면
                        {
                            [Score addObject:matchScore];
                            
                        }
                    }
                    else{

                    }
                }
                
                if([currentChosenCards count] == 0)
                {
                    self.score-= MISMATCH_PENALTY;
                    self.cardOne = card.contents;
                    self.matchState = 4;
                    self.cardTwo = nil;
                    self.cardSam = nil;
                }
                if([currentChosenCards count] == 1)
                {
                    Card *temp = [currentChosenCards objectAtIndex:0];
                    self.cardTwo = temp.contents;
                    self.cardOne = card.contents;
                    self.cardSam = nil;
                    printf("%s\n", [self.cardTwo UTF8String]);
                }
                else if([currentChosenCards count] == 2)
                {
                    Card *temp1 = [currentChosenCards objectAtIndex:0];
                    Card *temp2 = [currentChosenCards objectAtIndex:1];
                    self.cardOne = card.contents;
                    self.cardTwo = temp1.contents;
                    self.cardSam = temp2.contents;
                    //NSNumber *totalScore;
                    
                    
                    
                    if([Score count] == 0)
                    {
                        temp1.chosen = NO;
                        temp2.chosen = NO;
                        self.matchState = 7;
                    }
                    else if([Score count] == 1)
                    {
                        //self.score += matchScore * MATCH_BONUS;
                        temp1.matched = YES;
                        temp2.matched = YES;
                        card.matched = YES;

                        self.matchState = 5;
                    }
                    else if([Score count] >= 2)
                    {
                        //self.score += matchScore * MATCH_BONUS;
                        temp1.matched = YES;
                        temp2.matched = YES;
                        card.matched = YES;

                        self.matchState = 6;
                    }
                    [currentChosenCards removeAllObjects];
                    [Score removeAllObjects];
                    
                }

                
                
                
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
                //선택시 점수를 깎을 수 있다.
            }
            
            
            
        }
    }
}
@end
