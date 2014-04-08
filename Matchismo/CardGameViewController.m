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

//init
- (IBAction)initGame:(id)sender
{
    self.game = nil;
    [self updateUI ];
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
    if(self.game.matchState == 2)
    {
        self.matchLabel.text = [NSString stringWithFormat:@"Card [%@] and [%@] are matched. +4", self.game.cardOne, self.game.cardTwo];
    }
    else if(self.game.matchState == 3){
        self.matchLabel.text = @"MisMatched -2";
    }
    else{
        self.matchLabel.text = @"";
    }
    //[self.game.cardOne stringByAppendingString:self.game.cardTwo];
    //[rankStrings[self.rank] stringByAppendingString:self.suit]
    
}


-(NSString *)titleForCard:(Card *)card
{
    //return card.isChosen ? card.contents : @"";
    return card.isChosen ? card.contents : @"";
}
         
-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront":@"cardback"];
}
         

@end
