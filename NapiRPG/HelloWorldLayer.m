//
//  HelloWorldLayer.m
//  NapiRPG
//
//  Created by Teo Maragakis on 2/4/12.
//  Copyright studio nocturnart 2012. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"



// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@synthesize tileMap = _tileMap;
@synthesize background = _bg2;
@synthesize bg2 = _background;
@synthesize foreground = _foreground;
@synthesize player = _player;
@synthesize meta = _meta;
@synthesize envitems = _envitems;

// on "init" you need to initialize your instance
-(id) init
{
    if( (self=[super init] )) {
        
        // Create layers & objects
        
        self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
        self.envitems = [_tileMap layerNamed:@"Pickable"];
        self.bg2 = [_tileMap layerNamed:@"bg2"];
        self.foreground = [_tileMap layerNamed:@"foreground"];
        self.meta = [_tileMap layerNamed:@"Meta"];
        _meta.visible = NO;
        CCTMXObjectGroup *objects = [_tileMap objectGroupNamed:@"Objects"];
        NSAssert(objects != nil, @"'Objects' object group not found");
        NSMutableDictionary *spawnPoint = [objects objectNamed:@"SpawnPoint"];        
        NSAssert(spawnPoint != nil, @"SpawnPoint object not found");
        int x = [[spawnPoint valueForKey:@"x"] intValue];
        int y = [[spawnPoint valueForKey:@"y"] intValue];
        
        self.player = [CCSprite spriteWithFile:@"napi2.png"];
        _player.position = ccp(x, y);
        //[_player setVertexZ:0];
        [self addChild:_tileMap z:-1];
        [self.tileMap addChild:_player z:[[_tileMap layerNamed:@"bg2"] zOrder]];
        //[self addChild:_player z:0];
  
        
             
        [self setViewpointCenter:_player.position];
        
        
        self.isTouchEnabled = YES;

        
    
    }
    return self;
}

- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / _tileMap.tileSize.width;
    int y = ((_tileMap.mapSize.height * _tileMap.tileSize.height) - position.y) / _tileMap.tileSize.height;
    return ccp(x, y);
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self 
                                                     priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) setPlayerPosition:(CGPoint)position {
	CGPoint tileCoord = [self tileCoordForPosition:position];
    int tileGid = [_meta tileGIDAt:tileCoord];
    if (tileGid) {
        NSDictionary *properties = [_tileMap propertiesForGID:tileGid];
        if (properties) {
            NSString *collision = [properties valueForKey:@"Collidable"];
            if (collision && [collision compare:@"True"] == NSOrderedSame) {
                return;
            }
            NSString *collectable = [properties valueForKey:@"Collectable"];
            if (collectable && [collectable compare:@"True"] == NSOrderedSame) {
                [_meta removeTileAt:tileCoord];
                [_envitems removeTileAt:tileCoord];
            }
        }
    }
    _player.position = position;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    CGPoint playerPos = _player.position;
    CGPoint diff = ccpSub(touchLocation, playerPos);
    if (abs(diff.x) > abs(diff.y)) {
        if (diff.x > 0) {
            playerPos.x += _tileMap.tileSize.width;
        } else {
            playerPos.x -= _tileMap.tileSize.width; 
        }    
    } else {
        if (diff.y > 0) {
            playerPos.y += _tileMap.tileSize.height;
        } else {
            playerPos.y -= _tileMap.tileSize.height;
        }
    }
    
    if (playerPos.x <= (_tileMap.mapSize.width * _tileMap.tileSize.width) &&
        playerPos.y <= (_tileMap.mapSize.height * _tileMap.tileSize.height) &&
        playerPos.y >= 0 &&
        playerPos.x >= 0 ) 
    {
        
        [self setPlayerPosition:playerPos];
    }
    
    [self setViewpointCenter:_player.position];
    
}

-(void) setViewpointCenter:(CGPoint) position {
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (_tileMap.mapSize.width * _tileMap.tileSize.width) 
            - winSize.width / 2);
    y = MIN(y, (_tileMap.mapSize.height * _tileMap.tileSize.height) 
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
	self.tileMap = nil;
    self.background = nil;
    self.player = nil;
    self.meta = nil;
    self.envitems = nil;
    self.bg2 = nil;
    self.foreground = nil;
	
    // don't forget to call "super dealloc"
	[super dealloc];
}
@end
