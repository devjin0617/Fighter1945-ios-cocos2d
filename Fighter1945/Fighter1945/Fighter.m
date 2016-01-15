//
//  Fighter.m
//  Fighter1945
//
//  Created by kim cheonjin on 08/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "Fighter.h"
#import "CollidableSprite.h"




@implementation Fighter
+ (id)fighter {
    Fighter *obj = [super spriteWithFile:@"fighter.png"];
    return obj;
}

- (void)move {
    if (_speed == 0)
    {
        return;
    }

    CGPoint dxdy = ccpMult(ccpForAngle(_direction), _speed);
    CGPoint newPosition = ccpAdd(self.position, dxdy);


    // Window 밖으로 안나가게 처리하는 부분
    CGRect window;
    window.origin = ccp(0, 0);
    window.size = [[CCDirector sharedDirector] winSize];

    if (CGRectContainsPoint(window, newPosition))
    {
        self.position = newPosition;
    }


}

@end
