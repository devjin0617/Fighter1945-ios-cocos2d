//
//  IntroLayer.m
//  Fighter1945
//
//  Created by kim cheonjin on 08/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import <CoreGraphics/CoreGraphics.h>
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import "BattleFieldLayer.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

- (void)showCredits {


}

- (void)startGame {
    CCScene *gameScene = [BattleFieldLayer scene];
    CCTransitionMoveInT *transition = [CCTransitionMoveInT transitionWithDuration:0.1 scene:gameScene];
    [[CCDirector sharedDirector] replaceScene:transition];

}

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];

	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];

	// add layer as a child to scene
	[scene addChild:layer];

	// return the scene
	return scene;
}

//

- (id)init {
    //self = [super init];
    self = [super initWithColor:ccc4(24, 73, 156, 255)];
    if (self) {



        CGSize winsize = [[CCDirector sharedDirector] winSize];

        CCSprite *logo = [CCSprite spriteWithFile:@"logo.png"];
        logo.anchorPoint = CGPointMake(0.5, 0.5);
        logo.position = ccp(winsize.width*0.6, winsize.height*0.75);
        [self addChild:logo];


        CCMenuItem *item1 = [CCMenuItemFont itemFromString:@"Start Game" target:self selector:@selector(startGame)];
        //CCMenuItemImage *item2 = [CCMenuItemImage itemFromNormalImage:@"credits_normal.png" selectedImage:@"credits_selected.png" target:self selector:@selector(showCredits)];
        CCMenuItem *item2 = [CCMenuItemFont itemFromString:@"Credits" target:self selector:@selector(showCredits)];

        item1.isEnabled = YES;
        item2.isEnabled = YES;

        CCMenu *menu = [CCMenu menuWithItems:item1, item2, nil];
        [menu alignItemsVerticallyWithPadding:5.0];

        menu.anchorPoint = ccp(0.5, 0.5);
        menu.position = ccp(winsize.width/2, winsize.height*0.3);
        [self addChild:menu];



    }

    return self;
}


@end
