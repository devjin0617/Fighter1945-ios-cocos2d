//
//  BossBullet.m
//  Fighter1945
//
//  Created by kim cheonjin on 08/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "BossBullet.h"
#import "SimpleAudioEngine.h"
#import "BattleFieldLayer.h"


@implementation BossBullet
+ (id)bossBulletIn:(BattleFieldLayer *)layer {

    BossBullet *bossBullet = [super spriteWithFile:@"boss_bullet.png"];
    bossBullet.battleField = layer;
    return bossBullet;
}

- (void)removeBossBullet {
    [self.battleField removeChild:self cleanup:YES];

}


- (void)move {
    CGSize enemySize = self.contentSize;
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    int initY = winSize.height + enemySize.height;
    int initX = (arc4random() % (int)(winSize.width - enemySize.width) ) + enemySize.width / 2;


    int destY = -enemySize.height;
    int destX = (arc4random() % (int)(winSize.width - enemySize.width)) + enemySize.width / 2;

    self.position = ccp(winSize.width/2, winSize.height-80);
    self.anchorPoint = ccp(0.5, 0.5);

    int minDuration = 1.0;
    int maxDuration = 2.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;

    id moveAction = [CCMoveTo actionWithDuration:actualDuration position:ccp(destX, destY)];
    id removeAction = [CCCallFunc actionWithTarget:self selector:@selector(removeBossBullet)];

    [self runAction:[CCSequence actions:moveAction, removeAction, nil]];

}

- (void)explode:(CCAnimation *)explosionAni{

    [self stopAllActions];

    id explosionAction = [CCAnimate actionWithAnimation:explosionAni];
    id removeAction = [CCCallFunc actionWithTarget:self selector:@selector(removeBossBullet)];

    [self runAction:[CCSequence actions:explosionAction, removeAction, nil]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.aif"];


}

@end
