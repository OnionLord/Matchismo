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
    self.game = nil;
    [self updateUI ];
}

- (IBAction)selectMatch:(id)sender
{
    self.matchSegment.enabled = NO;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
    
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
    if(self.game.matchState == 2)
    {
        self.matchSegment.enabled = NO;
        self.matchLabel.text = [NSString stringWithFormat:@"Card [%@] and [%@] are matched. +4", self.game.cardOne, self.game.cardTwo];//일치할 경우의 메시지
    }
    else if(self.game.matchState == 3){
        self.matchSegment.enabled = NO;
         self.matchLabel.text = [NSString stringWithFormat:@"Card [%@] and [%@] are mismatched. -2", self.game.cardOne, self.game.cardTwo];//불일치할 경우의 메시지
    }
    else if(self.game.matchState == 4)
    {
        self.matchSegment.enabled = NO;
        self.matchLabel.text = [NSString stringWithFormat:@"Select [%@]", self.game.cardTwo];//하나만 선택시 메시지
    }
    else{
        self.matchLabel.text = @"";//초기화시 상태창을 비워둔다.
        //2개 선택할지 3개 선택할지 선택하게 한다.
        self.matchSegment.enabled = YES;
        [self.matchSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
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
