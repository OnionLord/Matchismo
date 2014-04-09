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

    self.matchLabel.text = self.game.matchMessage;



    
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
