//
//  Enemy.m
//  Fighter1945
//
//  Created by kim cheonjin on 08/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "CollidableSprite.h"
#import "Enemy.h"
#import "BattleFieldLayer.h"
#import "SimpleAudioEngine.h"


@implementation Enemy
+ (id)enemyIn:(BattleFieldLayer *)layer {
    Enemy *enemy = [super spriteWithFile:@"enemy.png"];
    enemy.battleField = layer;
    return enemy;
}

- (void)removeEnemy {
    [self.battleField removeChild:self cleanup:YES];

}


- (void)move {
    CGSize enemySize = self.contentSize;
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    int initY = winSize.height + enemySize.height;
    int initX = (arc4random() % (int)(winSize.width - enemySize.width) ) + enemySize.width / 2;


    int destY = -enemySize.height;
    int destX = (arc4random() % (int)(winSize.width - enemySize.width)) + enemySize.width / 2;

    self.position = ccp(initX, initY);

    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;

    id moveAction = [CCMoveTo actionWithDuration:actualDuration position:ccp(destX, destY)];
    id removeAction = [CCCallFunc actionWithTarget:self selector:@selector(removeEnemy)];

    [self runAction:[CCSequence actions:moveAction, removeAction, nil]];

}

- (void)explode:(CCAnimation *)explosionAni{

    [self stopAllActions];

    id explosionAction = [CCAnimate actionWithAnimation:explosionAni];
    id removeAction = [CCCallFunc actionWithTarget:self selector:@selector(removeEnemy)];

    [self runAction:[CCSequence actions:explosionAction, removeAction, nil]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.aif"];


}

@end
