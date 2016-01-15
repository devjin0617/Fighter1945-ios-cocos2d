//
//  CollidableSprite.m
//  Fighter1945
//
//  Created by kim cheonjin on 08/09/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "CollidableSprite.h"
#import "BossBullet.h"


@implementation CollidableSprite


- (BOOL)isCollide:(CCNode *)node onlyContains:(BOOL)contains {

    CGRect rectSelf;
    rectSelf.origin = ccpAdd(self.position, ccpMult(ccpFromSize(self.contentSize), -0.5));
    rectSelf.size = self.contentSize;



    CGRect rectOther;
    rectOther.origin = ccpAdd(node.position, ccpMult(ccpFromSize(node.contentSize), -0.5));
    rectOther.size = node.contentSize;

    if (contains)
    {
        return CGRectContainsRect(rectSelf, rectOther);
    }
    else
    {
        // 두 Sprite 간의 거리가 너비, 높이 70% 정도 이내일 경우
        CGFloat dist = ccpDistance(self.position, node.position);
        if([node isKindOfClass:[BossBullet class]])
        {
            return ((dist < (self.contentSize.width * 0.2)) || (dist < (self.contentSize.height * 0.2)));
        }


        return ((dist < (self.contentSize.width * 0.7)) || (dist < (self.contentSize.height * 0.7)));

    }


}


@end
