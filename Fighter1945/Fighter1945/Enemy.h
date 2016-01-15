//
//  Enemy.h
//  Fighter1945
//
//  Created by kim cheonjin on 08/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class BattleFieldLayer;

@interface Enemy : CollidableSprite

@property (weak) BattleFieldLayer *battleField;

+ (id)enemyIn:(BattleFieldLayer *)layer;
- (void)move;
- (void)removeEnemy;
- (void)explode:(CCAnimation *)explosionAni;

@end
