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
@property (strong, nonatomic) IBOutlet UISlider *historyBar;//이전에 했던거 UI슬라이드
@property (strong, nonatomic) NSMutableArray *gameHistory;//일치 불일치 선택 등 아래 라벨에서 나오는 메시지 저장.
@end

@implementation CardGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.gameHistory = [[NSMutableArray alloc] init];
}

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
- (IBAction)viewHistoryByUISlide:(id)sender
{

    if([self.gameHistory count])
    {
        NSString *historySelectedByUISlide;
        //슬라이드를 움직이면서 과거 몇턴 전이었는지 같이 표기해준다.
        if([self.gameHistory count] - 1 != (int)self.historyBar.value)
        {
            historySelectedByUISlide = [NSString stringWithFormat:@"%@\nBefore %d Turns",
                                        [self.gameHistory objectAtIndex:(int)self.historyBar.value],
                                        [self.gameHistory count] - (int)self.historyBar.value - 1];
        }
        else
        {//맨 끝의 내용 : 현재 상태가 저장됨 으로 가면 과거라는 표식을 없앤다
            historySelectedByUISlide = [NSString stringWithFormat:@"%@",
                                        [self.gameHistory objectAtIndex:(int)self.historyBar.value]];
        }
        self.matchLabel.text = historySelectedByUISlide;
    }
}

//게임 초기화 버튼 클릭시
//이전 게임의 내용을 nil로 해서 버리고
//다시 업데이트를 한다.
- (IBAction)initGame:(id)sender
{
    self.matchSegment.enabled = YES;
    [self.matchSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
    //히스토리슬라이드바 초기화
    self.historyBar.value = 0;
    self.historyBar.maximumValue = 0;
    [self.gameHistory removeAllObjects];
    
    
    self.game = nil;
    [self updateUI ];
}

- (IBAction)selectMatch:(id)sender
{
    [self.game selectType:self.matchSegment.selectedSegmentIndex];
    self.matchSegment.enabled = NO;
    
    //히스토리 배열 초기화 -> 게임 타입 선택한 시점부터 게임이 시작되므로
    NSString *gameStartState = @"Game Started";
    self.matchLabel.text = gameStartState;
    [self.gameHistory addObject:gameStartState];
    
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
    //스코어 창에 현재 스코어 표시
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : %d", self.game.score];
    //현재 진행중인 사항 표시
    NSString *matchStateMessage= self.game.matchMessage;
    self.matchLabel.text = matchStateMessage;
    //히스토리 배열에 현재 상황 저장.
    if(matchStateMessage)
    {
        [self.gameHistory addObject:matchStateMessage];
        [self.historyBar setMaximumValue:[self.gameHistory count]-1];
        self.historyBar.value = [self.gameHistory count];
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
