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



-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
   //
    if(self.selectedMatch == 2)
    {
        if(!card.isMatched)
        {
            if(card.isChosen)
            {
                card.chosen = NO;
                self.matchMessage = @"";
                self.cardOne = nil;
                self.cardTwo = nil;
                self.cardSam = nil;
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
                            self.givenScore = matchScore * MATCH_BONUS;
                            otherCard.matched = YES;
                            card.matched = YES;
                            self.cardOne = card.contents;
                            self.cardTwo = otherCard.contents;
                            self.matchMessage = [NSString stringWithFormat:@"Card [%@] and [%@] are matched. +%d", self.cardOne, self.cardTwo, self.givenScore];
                            //일치된 경우 각 카드의 컨텐츠를 저장하고 일치된 state로 바꾼다.
                            //일치의 경우 지정된 보너스를 받는다
                        }
                        else{
                            self.score-= MISMATCH_PENALTY;
                            self.givenScore = MISMATCH_PENALTY;
                            otherCard.chosen = NO;
                            self.cardOne = card.contents;
                            self.cardTwo = otherCard.contents;
                            self.matchMessage = [NSString stringWithFormat:@"Card [%@] and [%@] are mismatched. -%d", self.cardOne, self.cardTwo, self.givenScore];
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
                        self.matchMessage = [NSString stringWithFormat:@"Select [%@]", self.cardOne];
                        //하나만 선택된 상태
                    }
                }
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
                //선택시 점수를 깎을 수 있다.
            }
            

        }
    }
    else if(self.selectedMatch == 3)
    {
        NSMutableArray *currentChosenCards = [[NSMutableArray alloc] init];
        Card * otherCard1;
        Card * otherCard2;
        if(!card.isMatched)
        {
            if(card.isChosen)
            {
                //3개 이상 모드에서는 구현상의 한계로 낙장불입 모드.
                //self.matchMessage = @"";

            }
            else{
                
                for(Card *otherCard in self.cards)//특정 개수 만큼 선택하면서 배열에 넣는다. 3개 선택시 현재 선택 제외하고 이전에 선택된 2개가 들어간다.
                {
                    if(otherCard.isChosen && !otherCard.isMatched)
                    {
                        [currentChosenCards addObject:otherCard];
                        
                        
                    }
                }

                printf("%s\n", [card.contents UTF8String]);
                if([currentChosenCards count ] == 0)
                {
                    self.cardOne = card.contents;
                    self.cardTwo = nil;
                    self.cardSam = nil;
                    self.matchMessage = [NSString stringWithFormat:@"Select [%@]", self.cardOne];
                }
                else if([currentChosenCards count] == 1)
                {
                    otherCard1 = [currentChosenCards objectAtIndex:0];
                    self.cardOne = card.contents;
                    self.cardTwo = otherCard1.contents;
                    self.cardSam = nil;
                    self.matchMessage = [NSString stringWithFormat:@"Select [%@] and [%@]", self.cardTwo, self.cardOne];
                }
                else if([currentChosenCards count] == 2)//3개 모두 선택시, 현재 선택 제외한 2개가 배열에 들어갈 때
                {

                    otherCard1 = [currentChosenCards objectAtIndex:0];
                    otherCard2 = [currentChosenCards objectAtIndex:1];
                    
                    int matchScore1 = [card match:@[otherCard1]];
                    int matchScore2 = [card match:@[otherCard2]];
                    int matchScore3 = [otherCard1 match:@[otherCard2]];
                    
                    
                    if(!matchScore1 && !matchScore2 && !matchScore3)//모두가 매치가 되지 않았을 때
                    {
                        self.score-= MISMATCH_PENALTY;
                        self.givenScore = MISMATCH_PENALTY;
                        otherCard1.chosen = NO;
                        otherCard2.chosen = NO;
                        self.cardOne = card.contents;
                        self.cardTwo = otherCard1.contents;
                        self.cardSam = otherCard2.contents;
                        self.matchMessage = [NSString stringWithFormat:@"Card [%@], [%@] and [%@] are mismatched. -%d", self.cardOne, self.cardTwo, self.cardSam, self.givenScore];//불일치할 경우의 메시지

                    }
                    else//점수 얻는 경우 : 한쌍만 맞을때, 두 쌍 이상 맞을 때
                    {
                        if(matchScore1 && !matchScore2 && !matchScore3)//한쌍만 맞는 경우. 안맞는 것을 cardSam에 두어 출력시 구분하게함
                        {
                            self.cardOne = card.contents;
                            self.cardTwo = otherCard1.contents;
                            self.cardSam = otherCard2.contents;
                            self.score += matchScore1 * MATCH_BONUS;
                            self.givenScore = matchScore1 * MATCH_BONUS;
                            self.matchMessage = [NSString stringWithFormat:@"Card [%@] and [%@] are matched. not[%@] +%d", self.cardOne, self.cardTwo, self.cardSam, self.givenScore];//메시지
                        }
                        else if(!matchScore1 && matchScore2 && !matchScore3)
                        {
                            self.cardOne = card.contents;
                            self.cardTwo = otherCard2.contents;
                            self.cardSam = otherCard1.contents;
                            self.score += matchScore2 * MATCH_BONUS;
                            self.givenScore = matchScore2 * MATCH_BONUS;
                            self.matchMessage = [NSString stringWithFormat:@"Card [%@] and [%@] are matched. not[%@] +%d", self.cardOne, self.cardTwo, self.cardSam, self.givenScore];//메시지
                        }
                        else if(!matchScore1 && !matchScore2 && matchScore3)
                        {
                            self.cardOne = otherCard1.contents;
                            self.cardTwo = otherCard2.contents;
                            self.cardSam = card.contents;
                            self.score += matchScore3 * MATCH_BONUS;
                            self.givenScore = matchScore3 * MATCH_BONUS;
                            self.matchMessage = [NSString stringWithFormat:@"Card [%@] and [%@] are matched. not[%@] +%d", self.cardOne, self.cardTwo, self.cardSam, self.givenScore];//메시지
                        }
                        else//두 쌍 이상 맞는 경우
                        {

                            self.cardOne = card.contents;
                            self.cardTwo = otherCard1.contents;
                            self.cardSam = otherCard2.contents;
                            self.score += (matchScore1+matchScore2+matchScore3) * MATCH_BONUS;
                            self.givenScore = (matchScore1+matchScore2+matchScore3) * MATCH_BONUS;
                            self.matchMessage = [NSString stringWithFormat:@"Card [%@], [%@] and [%@] are matched. +%d", self.cardOne, self.cardTwo, self.cardSam, self.givenScore];//불일치할 경우의 메시지
                        }
                        //한 쌍만 맞아도 세개의 카드 모두 버리는 것으로 한다.
                        card.matched = YES;
                        otherCard1.matched = YES;
                        otherCard2.matched = YES;
                    }
                    //초기화
                    [currentChosenCards removeAllObjects];

                }
                
                self.score -= COST_TO_CHOOSE;
                card.chosen = YES;
                //선택시 점수를 깎을 수 있다.
            }

            
        }
    }
}
@end
