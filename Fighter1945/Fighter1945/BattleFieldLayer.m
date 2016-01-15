//
//  BattleFieldLayer.m
//  Fighter1945
//
//  Created by kim cheonjin on 08/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "BattleFieldLayer.h"
#import "Fighter.h"
#import "Enemy.h"
#import "SimpleAudioEngine.h"
#import "GameEnd.h"
#import "Boss.h"
#import "BossBullet.h"

#define Z_PAD 96
#define Z_FIGHT 95

#define TAG_ENEMY 1
#define TAG_BULLET 2
#define TAG_BOMB 5

#define TAG_BOSS 1000

#define DEATH_POINT 10
#define BOSS_HP 250
#define BOMB_POWER 30;


@interface BattleFieldLayer()
{
    Fighter *fighter;
    CCSprite *joypad, *joybtn, *fireBtn, *bombBtn;
    BOOL isMovingJoybtn;

    NSMutableArray *enemies, *bullets, *bombs;
    Boss *boss;
    CCAnimation *explosionAni, *bombAni;


    int deathCount;
    BOOL isJoyTouchControl;
    BOOL isUserDeath;
    BOOL isBossDeath;
    int bombNumber;
    int bossHealth;
    BOOL bossCount;
    CCLabelTTF *bossHp;

    NSTimer *timer;
    NSTimeInterval startTime;
    NSTimeInterval stopTime;
    NSTimeInterval elapsedTime;

}
@end

@implementation BattleFieldLayer

+ (CCScene *)scene {
    CCScene *scene = [CCScene node];
    BattleFieldLayer *layer = [BattleFieldLayer node];
    [scene addChild:layer];

    return scene;
}




-(void)spriteMoveFinished:(id)sender
{
    CCSprite *sprite = (CCSprite *)sender;


    if(sprite.tag == TAG_BULLET)
    {
        [bullets removeObject:sprite];
    }

    if (sprite.tag == TAG_BOMB)
    {
        [bombs removeObject:sprite];
    }


    [self removeChild:sprite cleanup:YES];
}


-(void)checkCollision
{
    NSMutableArray *collidedBullets = [NSMutableArray array];

    for(CCSprite *bullet in bullets)
    {
        NSMutableArray *fallingEnemies = [NSMutableArray array];

        for(Enemy *enemy in enemies)
        {
            if ([enemy isCollide:bullet onlyContains:YES])
            {
                [fallingEnemies addObject:enemy];

            }


        }

        if(boss != nil)
        {
            if([boss isCollide:bullet onlyContains:YES])
            {
                bossHealth--;
                [collidedBullets addObject:bullet];
            }
            if(bossHealth <= 0)
            {

                [boss explode:explosionAni];

                isBossDeath = YES;

            }
        }



        // 총알이 맞은 적이 있으면 적을 삭제
        if ([fallingEnemies count] > 0)
        {
            for (Enemy *enemy in fallingEnemies)
            {
                /*

                [self removeChild:enemy cleanup:YES];
                [enemies removeObject:enemy];
                */
                [enemies removeObject:enemy];
                [enemy explode:explosionAni];
                deathCount++;
            }



            [collidedBullets addObject:bullet];
        }


    }


    //총알 삭제

    if([collidedBullets count] > 0)
    {
        for(CCSprite *bullet in collidedBullets)
        {
            [self removeChild:bullet cleanup:YES];
            [bullets removeObject:bullet];


        }
    }



    // 적과 충돌하면 게임 오버
    for(Enemy *enemy in enemies)
    {
        if([fighter isCollide:enemy onlyContains:NO])
        {
            CCLOG(@"Game Over");
            [self doExplosionEffectAndSound:fighter];
            [self doExplosionEffectAndSound:enemy];
            fighter.speed = 0;
            [fighter stopAllActions];
            [self stopAllActions];
            isUserDeath = YES;
        }

    }
    if(boss != nil)
    {
        if ([fighter isCollide:boss onlyContains:NO])
        {
            CCLOG(@"Game Over From Boss");
            [fighter stopAllActions];
            [self stopAllActions];
            fighter.speed = 0;
            [self doExplosionEffectAndSound:fighter];


            isUserDeath = YES;
        }
    }



}


-(void)doExplosionEffectAndSound:(id)targetLocation
{
    id explosionAction = [CCAnimate actionWithAnimation:explosionAni];
    id removeAction = [CCCallFunc actionWithTarget:self selector:@selector(doRemoveObject)];


    [targetLocation runAction:[CCSequence actions:explosionAction,removeAction, nil]];
    [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.aif"];
}

-(void)doRemoveObject
{
    if(fighter != nil)
    {
        [self removeChild:fighter cleanup:YES];
    }
}


//비행기만 처음에 띄웠을때
/*
- (id)init {
    //self = [super init];
    self = [super initWithColor:ccc4(8, 54, 129, 255)];
    if (self) {

        self.isTouchEnabled = YES;

        CGSize size = [[CCDirector sharedDirector] winSize];

        fighter = [CCSprite spriteWithFile:@"fighter.png"];

        fighter.scale = 0.15;
        fighter.position = ccp(size.width/2, size.height/2);

        [self addChild:fighter];

    }

    return self;
}
*/



-(void)shootTarget
{
    CCSprite *bullet = [CCSprite spriteWithFile:@"bullet.png"];
    bullet.tag = TAG_BULLET;

    bullet.position = fighter.position;

    CGSize winSize = [[CCDirector sharedDirector] winSize];

    CGPoint dest = ccp(fighter.position.x, winSize.height + bullet.contentSize.height);

    [self addChild:bullet z:2]; // 화면에 출력


    CCSprite *bullet2 = [CCSprite spriteWithFile:@"bullet.png"];
    bullet2.tag = TAG_BULLET;

    bullet2.position = ccp(fighter.position.x + 20, fighter.position.y);

    CGPoint dest2 = ccp(fighter.position.x + 20, winSize.height + bullet2.contentSize.height);

    [self addChild:bullet2 z:2]; // 화면에 출력

    [bullets addObject:bullet2]; // 총알 배열에 별도로 추가


    CCSprite *bullet3 = [CCSprite spriteWithFile:@"bullet.png"];
    bullet3.tag = TAG_BULLET;

    bullet3.position = ccp(fighter.position.x - 20, fighter.position.y);

    CGPoint dest3 = ccp(fighter.position.x - 20, winSize.height + bullet3.contentSize.height);

    [self addChild:bullet3 z:2]; // 화면에 출력

    [bullets addObject:bullet3]; // 총알 배열에 별도로 추가




    id actionFire = [CCMoveTo actionWithDuration:0.5 position:dest];
    id actionFire2 = [CCMoveTo actionWithDuration:1.0 position:dest2];
    id actionFire3 = [CCMoveTo actionWithDuration:1.0 position:dest3];

    id actionRemove = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
    [bullet runAction:[CCSequence actions:actionFire, actionRemove, nil]];
    [bullet2 runAction:[CCSequence actions:actionFire2, actionRemove, nil]];
    [bullet3 runAction:[CCSequence actions:actionFire3, actionRemove, nil]];

}

-(void)removeBombActionSprite
{
    CCSprite *bombSp = [self getChildByTag:22];
    [self removeChild:bombSp cleanup:YES];
}

-(void)shootBomb
{
    CCLOG(@"do Bomb");


    if(bombNumber > 0)
    {
        id bombAction = [CCAnimate actionWithAnimation:bombAni];

        CCSprite *bombSp = [CCSprite new];
        bombSp.tag = 22;
        CGSize wSize = [[CCDirector sharedDirector] winSize];
        bombSp.position = ccp(wSize.width/2., wSize.height/2);
        [self addChild:bombSp z:2];


        id removeAction = [CCCallFunc actionWithTarget:self selector:@selector(removeBombActionSprite)];
        [bombSp runAction:[CCSequence actions:bombAction, removeAction, nil]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"bomb_sound.mp3"];




        CCSprite *bomb = [self getChildByTag:bombNumber+ TAG_BOMB];
        [self removeChild:bomb cleanup:YES];

        bombNumber--;



        NSMutableArray *fallingEnemies = [NSMutableArray array];

        for(Enemy *enemy in enemies)
        {
            [fallingEnemies addObject:enemy];

        }

        for (Enemy *enemy in fallingEnemies)
        {
            /*

            [self removeChild:enemy cleanup:YES];
            [enemies removeObject:enemy];
            */
            [enemies removeObject:enemy];
            [enemy explode:explosionAni];
            deathCount++;
        }

        if(boss != nil)
        {
            bossHealth -= BOMB_POWER;
        }


    }




}

-(void)addBoss
{
    boss = [Boss bossIn:self];
    boss.tag = TAG_BOSS;
    [boss move];

    [self addChild:boss z:2];
}


-(void)addEnemy:(ccTime)dt
{
    Enemy *enemy = [Enemy enemyIn:self];
    enemy.tag = TAG_ENEMY;
    [enemy move];

    [self addChild:enemy z:2];
    [enemies addObject:enemy];

    /*
    CCSprite *enemy = [CCSprite spriteWithFile:@"enemy.png"];
    CGSize enemySize = enemy.contentSize;
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    int initY = winSize.height + enemySize.height;
    int initX = (arc4random() % (int)(winSize.width - enemySize.width) ) + enemySize.width / 2;


    int destY = -enemySize.height;
    int destX = (arc4random() % (int)(winSize.width - enemySize.width)) + enemySize.width / 2;

    enemy.position = ccp(initX, initY);

    [self addChild:enemy]; // 화면에 추가

    [enemies addObject:enemy]; // 적 배열에 추가


    int minDuration = 2.0;
    int maxDuration = 4.0;
    int rangeDuration = maxDuration - minDuration;
    int actualDuration = (arc4random() % rangeDuration) + minDuration;

    id actionMove = [CCMoveTo actionWithDuration:actualDuration position:ccp(destX, destY)];
    id actionRemove = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];

    [enemy runAction:[CCSequence actions:actionMove, actionRemove, nil]];
     */
}

-(BOOL)isTouchingJoybtn:(UITouch *)touch
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    return ccpDistance(joybtn.position, touchPoint) < (joybtn.contentSize.width / 2);
}

-(BOOL)isTouchingFireBtn:(UITouch *)touch
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    return ccpDistance(fireBtn.position, touchPoint) < (fireBtn.contentSize.width / 2);
}

-(BOOL)isTouchingBombBtn:(UITouch *)touch
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    return ccpDistance(bombBtn.position, touchPoint) < (bombBtn.contentSize.width / 2);
}



- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    CCLOG(@"ccTouchBegan");


    if (isJoyTouchControl)
    {
        for(UITouch *touch in [touches allObjects])
        {
            if ([self isTouchingJoybtn:touch])
            {
                isMovingJoybtn = YES;
            }
        }
    }


    //[super ccTouchesBegan:touches withEvent:event];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    CCLOG(@"ccTouchMoved");

    for(UITouch *touch in [touches allObjects])
    {
        if([self isTouchingJoybtn:touch] && YES == isMovingJoybtn)
        //if(YES == isMovingJoybtn)
        {
            [self moveJoybtn:touch];
        }
        else if (![self isTouchingJoybtn:touch] && ![self isTouchingFireBtn:touch])
        {
            CCLOG(@"isTouchingJoybtn !");




        }
    }

    //[super ccTouchesMoved:touches withEvent:event];
}


- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for(UITouch *touch in [touches allObjects])
    {
        if ([self isTouchingJoybtn:touch] && YES == isMovingJoybtn)
        {
            joybtn.position = joypad.position;
            fighter.speed = 0;
            isMovingJoybtn = NO;
        }
        else if (![self isTouchingJoybtn:touch] && ![self isTouchingFireBtn:touch] && ![self isTouchingBombBtn:touch])
        {
            joybtn.position = joypad.position;
        }
        else if ([self isTouchingFireBtn:touch])
        {
            [self shootTarget];
        }
        else if ([self isTouchingBombBtn:touch])
        {
            [self shootBomb];
        }
    }

    //[super ccTouchesEnded:touches withEvent:event];
}


#define MAX_JOYBTN_DIST (joypad.contentSize.width /2)

-(void)moveJoybtn:(UITouch *)touch
{
    CGPoint point = [self convertTouchToNodeSpace:touch];
    float dist = ccpDistance(point, joypad.position);
    float tempDisX = point.x - MAX_JOYBTN_DIST - joypad.position.x;
    float tempDisY = point.y - MAX_JOYBTN_DIST - joypad.position.y;

    float disX = point.x - tempDisX;
    float disY = point.y - tempDisY;

    CCLOG(@"point X : %f", disX);
    CCLOG(@"point Y : %f", disY);

    CCLOG(@"point X : %f", point.x);
    CCLOG(@"point Y : %f", point.y);

    CCLOG(@"joypad Position X : %f", joypad.position.x);
    CCLOG(@"joypad Position Y : %f", joypad.position.y);





    if (dist < MAX_JOYBTN_DIST)
    {
        joybtn.position = point;

    }
    else
    {
        CCLOG(@"ELSE");
    }
    // 패드 범위를 벗어났을때 ㅠㅠ???


    CGPoint delta = ccpSub(point, joypad.position);
    float angle = ccpToAngle(delta);

    fighter.speed = (int)dist / MAX_JOYBTN_DIST * 5;
    fighter.direction = angle;

}




- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {


    /*
    if([self isTouchingJoybtn:touch])
    {
        isMovingJoybtn = YES;

    }

    return YES;
    */

    //return [super ccTouchBegan:touch withEvent:event];
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {


    /*
    if(isMovingJoybtn)
    {
        [self moveJoybtn:touch];
    }
    //[super ccTouchMoved:touch withEvent:event];
    */
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {


    /*
    joybtn.position = joypad.position;
    fighter.speed = 0;
    isMovingJoybtn = NO;
    */

    /*
    CGPoint p = [self convertTouchToNodeSpace:touch];
    CCMoveTo *move = [CCMoveTo actionWithDuration:1 position:p];
    [fighter runAction:move];
    */
    //[super ccTouchEnded:touch withEvent:event];
}



-(void)checkDeathCount
{
    CCLabelTTF *deathCountObj = [self getChildByTag:90];
    [deathCountObj setString:[NSString stringWithFormat:@"kill : %i, score : %i", deathCount, [self scoreCalc]]];


    if(boss != nil)
    {
        if(bossHp != nil)
        {
            [bossHp setString:[NSString stringWithFormat:@"BOSS HP : %i", bossHealth]];

        }
        else
        {
            bossHp = [CCLabelTTF labelWithString:@"BOSS HP : " fontName:@"Marker Felt" fontSize:20];
            bossHp.position = ccp(70, 300 - deathCountObj.contentSize.height);
            [self addChild:bossHp z:90];

        }

    }
}

-(void)bossBulletStart:(ccTime)dt
{
    BossBullet *bossBullet = [BossBullet bossBulletIn:self];
    bossBullet.tag = TAG_BOSS;
    [bossBullet move];

    [self addChild:bossBullet z:2];
    [enemies addObject:bossBullet];
}

-(void)updateTimer
{
       stopTime = [NSDate timeIntervalSinceReferenceDate];
}

-(int)scoreCalc
{
    [timer invalidate];
    stopTime = [NSDate timeIntervalSinceReferenceDate];
    elapsedTime = stopTime - startTime;

    int sum=0;
    sum += deathCount * 60;
    sum -= elapsedTime;


    return sum;

}

-(void)checkGameEnd
{

    if(deathCount > DEATH_POINT )
    {

        if(bossCount)
        {
            [self addBoss];
            bossCount = NO;
            [self schedule:@selector(bossBulletStart:) interval:1.0];
        }
        if(bossHealth < 50 && bossHealth > 0)
        {
            [self schedule:@selector(bossBulletStart:) interval:0.3];

        }


    }
    if(isBossDeath)
    {
        [self stopAllActions];
        fighter.speed = 0;



        boss = nil;
        bossHp = nil;


        GameEnd *endLayer = [[GameEnd alloc] init:YES setScore:[self scoreCalc]];



        [self addChild:endLayer z:100];
        [self unscheduleAllSelectors];

        self.isTouchEnabled = NO;
        [CCDirector sharedDirector].view.multipleTouchEnabled = NO;


        isJoyTouchControl = NO;

    }
    else if(isUserDeath)
    {
        [self stopAllActions];
        GameEnd *endLayer = [[GameEnd alloc] init:NO setScore:[self scoreCalc]];


        boss = nil;
        [self addChild:endLayer z:100];
        [self unscheduleAllSelectors];

        self.isTouchEnabled = NO;
        [CCDirector sharedDirector].view.multipleTouchEnabled = NO;

        isJoyTouchControl = NO;

    }

}



- (id)init {
    //self = [super init];
    self = [super initWithColor:ccc4(8, 54, 129, 255)];
    if (self) {

        deathCount = 0;
        isJoyTouchControl = YES;
        isUserDeath = NO;
        isBossDeath = NO;
        bossHealth = BOSS_HP;
        bombNumber = 3;
        bossCount = YES;

        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateTimer) userInfo:self repeats:YES];
        startTime = [NSDate timeIntervalSinceReferenceDate];


        CGSize winSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        [CCDirector sharedDirector].view.multipleTouchEnabled = YES;

        CCLabelTTF *deathLabel = [CCLabelTTF labelWithString:@"kill : " fontName:@"Marker Felt" fontSize:20];
        deathLabel.tag = 90;
        deathLabel.position = ccp(100, 300);
        [self addChild:deathLabel z:90];




        CCSprite *map = [CCSprite spriteWithFile:@"map.png"];
        map.position = ccp(winSize.width/2, map.contentSize.height-300);
        map.scale = 1.8;
        [self addChild:map z:1];

        CGPoint dest = ccp(map.position.x, winSize.height-map.contentSize.height+100);

        id actionFire = [CCMoveTo actionWithDuration:30 position:dest];
        [map runAction:[CCSequence actions:actionFire, nil]];

        fighter = [Fighter spriteWithFile:@"fighter.png"];
        fighter.position = ccp(winSize.width/2, winSize.height/2-50);

        joypad = [CCSprite spriteWithFile:@"joypad.png"];
        joypad.position = ccp(70, 70);

        joybtn = [CCSprite spriteWithFile:@"joybtn.png"];
        joybtn.position = ccp(70, 70);

        fireBtn = [CCSprite spriteWithFile:@"firebtn.png"];
        fireBtn.position = ccp(winSize.width - (fireBtn.contentSize.width), 70);

        bombBtn = [CCSprite spriteWithFile:@"bomb_btn.png"];
        bombBtn.position = ccp(winSize.width - (fireBtn.contentSize.width) - (bombBtn.contentSize.width) - 10, 50);

        CCSprite *bombItem = [CCSprite spriteWithFile:@"bomb.png"];
        bombItem.tag = 1+ TAG_BOMB;
        CCSprite *bombItem2 = [CCSprite spriteWithFile:@"bomb.png"];
        bombItem2.tag = 2+ TAG_BOMB;
        CCSprite *bombItem3 = [CCSprite spriteWithFile:@"bomb.png"];
        bombItem3.tag = 3+ TAG_BOMB;
        bombItem.position = ccp(winSize.width - (bombItem.contentSize.width * 1), winSize.height - 20);
        bombItem2.position = ccp(winSize.width - (bombItem.contentSize.width * 2), winSize.height - 20);
        bombItem3.position = ccp(winSize.width - (bombItem.contentSize.width * 3), winSize.height - 20);

        [self addChild:bombItem z:Z_PAD];
        [self addChild:bombItem2 z:Z_PAD];
        [self addChild:bombItem3 z:Z_PAD];

        enemies = [NSMutableArray new];
        bullets = [NSMutableArray new];
        bombs = [NSMutableArray new];


        [self addChild:fighter z:2];
        [self addChild:joypad z:3];
        [self addChild:joybtn z:3];
        [self addChild:fireBtn z:Z_PAD];
        [self addChild:bombBtn z:Z_PAD];



        [fighter schedule:@selector(move)];
        [self schedule:@selector(addEnemy:) interval:0.8];
        [self schedule:@selector(checkCollision) interval:1/40];
        [self schedule:@selector(checkDeathCount) interval:1/40];
        [self schedule:@selector(checkGameEnd) interval:1/40];




        // explosion Add
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"explosion.plist"];
        NSMutableArray *explosionFrames = [NSMutableArray array];

        for(int i = 0 ; i<7 ; i++)
        {
            NSString *frameName = [NSString stringWithFormat:@"explosion%d.png", i];
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
            [explosionFrames addObject:frame];
        }



        explosionAni = [CCAnimation animationWithFrames:explosionFrames delay:0.1];


        // bomb add
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bombpng.plist"];
        NSMutableArray *bombFrames = [NSMutableArray array];

        for(int i = 1 ; i<12 ; i++)
        {
            NSString *bFrameName;
            if(i >= 10)
            {
                bFrameName = [NSString stringWithFormat:@"ex%d.png", i];
            }
            else
            {
                bFrameName = [NSString stringWithFormat:@"ex0%d.png", i];
            }
            CCSpriteFrame *bFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:bFrameName];
            [bombFrames addObject:bFrame];
        }



        bombAni = [CCAnimation animationWithFrames:bombFrames delay:0.1];

        //bombAni = [CCAnimation animationWithSpriteFrames:bombFrames delay:0.1];



        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background_music.mp3"];
        //[self schedule:@selector(shootTarget) interval:0.3];




        [[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion.aif"];


    }

    return self;
}



@end
