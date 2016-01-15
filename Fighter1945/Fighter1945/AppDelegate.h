//
//  AppDelegate.h
//  Fighter1945
//
//  Created by kim cheonjin on 08/09/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (strong ,readonly) UINavigationController *navController;
@property (weak, readonly) CCDirectorIOS *director;

@end
