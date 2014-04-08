//
//  CardGameViewController.m
//  Matchismo
//
//  Created by KimSH on 3/15/14.
//  Copyright (c) 2014 COMP420. All rights reserved.
//

//2014.4.8 카드 30장 추가 및 초기화 버튼 생성.

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *matchSegment;
@end

@implementation CardGameViewController

-(CardMatchingGame *)game
{
    if(!_game)
        _game=[[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
    return _game;
}


-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

//게임 초기화 버튼 클릭시
//이전 게임의 내용을 nil로 해서 버리고
//다시 업데이트를 한다.
- (IBAction)initGame:(id)sender
{
    self.matchSegment.enabled = YES;
    [self.matchSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    self.game = nil;
    [self updateUI ];
}

- (IBAction)selectMatch:(id)sender
{
    [self.game selectType:self.matchSegment.selectedSegmentIndex];

    self.matchSegment.enabled = NO;
    
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    //segment에서 선택이 되어야 진행이 된다.
    if(self.matchSegment.selectedSegmentIndex != UISegmentedControlNoSegment)
    {
        int chosenButtonIndex = [self.cardButtons indexOfObject:    sender];
        [self.game chooseCardAtIndex:chosenButtonIndex];
        [self updateUI];
    }
}
-(void)updateUI
{
    for(UIButton *cardButton in self.cardButtons)
    {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : %d", self.game.score];
    //각 state마나 나타낼 메시지
    //state 설명, 현재 게임 상태
    //1 : 완전 새로 시작하는 경우
    //2 : (2개모드) 서로 일치하는 경우
    //3 : (2개모드) 일치 하지 않는 경우
    //4 : 하나만 선택된 경우
    //5 : (3개모드) 2개만 선택됨
    //6 : (3개모드) 모두 선택됨
    //7 : (3개모드) 모두 다름
    if(self.game.matchState == 2)
    {
        self.matchLabel.text = [NSString stringWithFormat:@"Card [%@] and [%@] are matched. +4", self.game.cardOne, self.game.cardTwo];//일치할 경우의 메시지
    }
    else if(self.game.matchState == 3){
         self.matchLabel.text = [NSString stringWithFormat:@"Card [%@] and [%@] are mismatched. -2", self.game.cardOne, self.game.cardTwo];//불일치할 경우의 메시지
    }
    else if(self.game.matchState == 4)
    {
        self.matchLabel.text = [NSString stringWithFormat:@"Select [%@]", self.game.cardOne];//하나만 선택시 메시지
    }
    else if(self.game.matchState == 1)//state==1, 초기화 하는 상황. 혹은 선택 취소
    {
        self.matchLabel.text = @"";
    }
    else if(self.game.matchState == 5)//state==5, 3개 모드일때 부분 선택
    {
        self.matchLabel.text = [NSString stringWithFormat:@"Card [%@], [%@], [%@] are partialy matched. +2", self.game.cardOne, self.game.cardTwo, self.game.cardSam];//불일치할 경우의 메시지
        
    }
    else if(self.game.matchState == 6)//state==6, 3개 모드일때 모두 선택
    {
        self.matchLabel.text = [NSString stringWithFormat:@"Card [%@], [%@], [%@] are all matched. +4", self.game.cardOne, self.game.cardTwo, self.game.cardSam];//불일치할 경우의 메시지
        
    }
    else if(self.game.matchState == 7)//state==7, 3개 모드일때 다 선택 안됨
    {
        self.matchLabel.text = [NSString stringWithFormat:@"Card [%@], [%@], [%@] are mismatched. -2", self.game.cardOne, self.game.cardTwo, self.game.cardSam];//불일치할 경우의 메시지

    }

    
}


-(NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}
         
-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront":@"cardback"];
}
         

@end
