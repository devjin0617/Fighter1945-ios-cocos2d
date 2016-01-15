//
//  GameEnd.m
//  Fighter1945
//
//  Created by kim cheonjin on 08/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "GameEnd.h"
#import "BattleFieldLayer.h"
#import "IntroLayer.h"


@interface GameEnd()



- (void)doRestart;
- (void)doMenu;


@end

@implementation GameEnd

- (id)init:(BOOL)finish setScore:(int)value{
    //self = [super init];
    self = [super initWithColor:ccc4(0, 0, 0, 150)];
    if (self) {


        self.scoreValue = value;

        CGSize size = [[CCDirector sharedDirector] winSize];
        CCLabelTTF *endText = nil;

        CCMenuItem *item1 = [CCMenuItemFont itemFromString:@"Restart" target:self selector:@selector(doRestart)];
        //CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"credits_normal.png" selectedImage:@"credits_selected.png" target:self selector:@selector(showCredits)];
        CCMenuItem *item2 = [CCMenuItemFont itemFromString:@"Menu" target:self selector:@selector(doMenu)];

        item1.isEnabled = YES;
        item2.isEnabled = YES;

        CCMenu *menu = [CCMenu menuWithItems:item1, item2, nil];
        [menu alignItemsHorizontallyWithPadding:20];

        menu.anchorPoint = ccp(0.5, 0.5);
        menu.position = ccp(size.width/2, size.height/2-50);
        [self addChild:menu];


        if (finish)
        {
            endText = [CCLabelTTF labelWithString:@"STAGE SUCCESS" fontName:@"Marker Felt" fontSize:50];
            self.scoreValue += 500;
        }
        else
        {
            endText = [CCLabelTTF labelWithString:@"GAME OVER" fontName:@"Marker Felt" fontSize:50];
        }


        NSString *scoreStr = [NSString stringWithFormat:@"USER SCORE : %i", self.scoreValue];

        CCLabelTTF *score = [CCLabelTTF labelWithString:scoreStr fontName:@"Marker Felt" fontSize:30];
        score.position = ccp(size.width/2,size.height/2 + 35 );
        [self addChild:score];

        endText.position = ccp(size.width/2,size.height/2 );
        [self addChild:endText];

    }

    return self;
}

- (void)doRestart {
    CCScene *gameScene = [BattleFieldLayer scene];
    CCTransitionMoveInT *transition = [CCTransitionMoveInT transitionWithDuration:0.1 scene:gameScene];
    [[CCDirector sharedDirector] replaceScene:transition];



}

- (void)doMenu {
    CCScene *gameScene = [IntroLayer scene];
    CCTransitionMoveInT *transition = [CCTransitionMoveInT transitionWithDuration:0.1 scene:gameScene];
    [[CCDirector sharedDirector] replaceScene:transition];

}


@end
