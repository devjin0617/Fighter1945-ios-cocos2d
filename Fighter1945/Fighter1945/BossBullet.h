//
//  BossBullet.h
//  Fighter1945
//
//  Created by kim cheonjin on 08/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CollidableSprite.h"

@class BattleFieldLayer;

@interface BossBullet : CollidableSprite

@property (weak) BattleFieldLayer *battleField;

+ (id)bossBulletIn:(BattleFieldLayer *)layer;
- (void)move;
- (void)removeBossBullet;
- (void)explode:(CCAnimation *)explosionAni;

@end
