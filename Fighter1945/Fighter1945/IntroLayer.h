//
//  IntroLayer.h
//  Fighter1945
//
//  Created by kim cheonjin on 08/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface IntroLayer : CCLayerColor


- (void)showCredits;
- (void)startGame;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;


@end
