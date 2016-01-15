//
//  Boss.m
//  Fighter1945
//
//  Created by kim cheonjin on 08/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "Boss.h"
#import "BattleFieldLayer.h"
#import "SimpleAudioEngine.h"


@implementation Boss

+ (id)bossIn:(BattleFieldLayer *)layer {
    Boss *boss = [super spriteWithFile:@"boss_small.png"];
    boss.battleField = layer;
    return boss;
}

- (void)removeBoss {
    [self.battleField removeChild:self cleanup:YES];

}


- (void)move {
    CGSize enemySize = self.contentSize;
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    self.position = ccp(winSize.width/2, winSize.height + 50);

    id moveAction = [CCMoveTo actionWithDuration:2 position:ccp(winSize.width/2, winSize.height-80)];


    [self runAction:[CCSequence actions:moveAction, nil]];

}

- (void)explode:(CCAnimation *)explosionAni{

    [self stopAllActions];

    id explosionAction = [CCAnimate actionWithAnimation:explosionAni];
    id removeAction = [CCCallFunc actionWithTarget:self selector:@selector(removeBoss)];

    [self runAction:[CCSequence actions:explosionAction, removeAction, nil]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.aif"];


}

@end
