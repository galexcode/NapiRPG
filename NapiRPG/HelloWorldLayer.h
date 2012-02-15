//
//  HelloWorldLayer.h
//  NapiRPG
//
//  Created by Teo Maragakis on 2/4/12.
//  Copyright studio nocturnart 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;
    CCSprite *_player;
    CCTMXLayer *_meta;
    CCTMXLayer *_envitems;
    CCTMXLayer *_bg2;
    CCTMXLayer *_foreground;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;
@property (nonatomic, retain) CCSprite *player;
@property (nonatomic, retain) CCTMXLayer *meta;
@property (nonatomic, retain) CCTMXLayer *envitems;
@property (nonatomic, retain) CCTMXLayer *bg2;
@property (nonatomic, retain) CCTMXLayer *foreground;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
