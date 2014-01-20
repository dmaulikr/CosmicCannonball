/**
 *  asteroidsScene.m
 *  asteroids
 *
 *  Created by Eric Schmitt on 9/20/12.
 *  Copyright __MyCompanyName__ 2012. All rights reserved.
 */

#import "asteroidsScene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CC3TargettingNode.h"
#import "CCSprite.h"
#import "CCTextureCache.h"
#import "CCLabelTTF.h"
#import "CCActionInstant.h"


@implementation asteroidsScene
@synthesize asteroids, playerLasers, shipAccelMod, wall, boom, diff, edgeTop, edgeBot, edgeRight, edgeLeft, canFire;

float RandomFloatBetween(float smallNumber, float bigNumber) {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

float RandomIntBetween(float smallNumber, float bigNumber) {
    float diff = bigNumber - smallNumber;
    return (((int) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}



-(void) dealloc {
    asteroids = nil;
    
    wall = nil;
    boom = nil;
    shipAccelMod = nil;
    diff = nil;;
	[super dealloc];
}

-(void)weaponFree {
    canFire = TRUE;
}

-(void)configureToDiff:(NSNumber *)pd {
    int multiplier = [pd intValue];
    
    tracker = 0;
	shotAlernator= 0;
	firstShot = TRUE;
	player_ship_size = 1.0;
    laserDamage = 10.0;
    bounceMultiplier = 4.0;
    enemyBounceMultiplier = 2.0;
    laser_size = 0.1;
    if(mapType==4) {
        asteroid_spawn_rate = 5/multiplier;
    } else if(mapType==2) {
        asteroid_spawn_rate = 10/multiplier;
    } else if(mapType==3) {
        asteroid_spawn_rate = 5/multiplier;
    } else {
        asteroid_spawn_rate = 16/multiplier;
    }
    
    roid_ship_damage = 20*multiplier;
    playerShipHealth = 100;
    diff = pd;
    
    if(mapType==1) scoreMod = 10*2*(multiplier + 1);
    else if(mapType==2) scoreMod = 10*(multiplier + 1);
    else if(mapType==3) scoreMod = 10/2*(multiplier + 1);
    else if(mapType==4) scoreMod = 10/2*(multiplier + 1);
}

-(void)configureToMapType:(NSNumber *)pd {
    mapType = [pd intValue];
    
    NSLog(@"Map: %d", mapType);
    if(mapType==1)
        [wall populateAsCenteredRectangleWithSize: CGSizeMake(500.0, 500.0)
                                      withTexture: [CC3Texture textureFromFile: @"bg1_p1.jpg"]
                                    invertTexture: YES ];
    
    else if(mapType==2)
        [wall populateAsCenteredRectangleWithSize: CGSizeMake(500.0, 500.0)
                                      withTexture: [CC3Texture textureFromFile: @"bg2_p1.png"]
                                    invertTexture: YES ];
    
    else if(mapType==3)
        [wall populateAsCenteredRectangleWithSize: CGSizeMake(500.0, 500.0)
                                      withTexture: [CC3Texture textureFromFile: @"bg3_p1.png"]
                                    invertTexture: YES ];
    
    else if(mapType==4)
        [wall populateAsCenteredRectangleWithSize: CGSizeMake(500.0, 500.0)
                                      withTexture: [CC3Texture textureFromFile: @"bg4_p1.png"]
                                    invertTexture: YES ];
}

-(void) initializeScene {
@try {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([[prefs valueForKey:@"sound"] isEqualToString:@"off"]) {
        soundEnabled = FALSE;
    } else {
        soundEnabled = TRUE;

    }
    
    
    if([[prefs valueForKey:@"invert"] isEqualToString:@"on"]) {
        invert = 1;
    } else {
        invert = -1;
    }
    
    spawn_counter = -100;
    
	myDele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
	orientated = false;
    
    canFire = TRUE;
    enemyCanFire = YES;
    isDead = FALSE;
    
    
    self.shipAccelMod = [NSNumber numberWithFloat:1.0];
    
    boom = [CC3Node nodeWithName:@"Boom"];
    boom.location = cc3v( 0.0, 5.0, -50.0 );
    
    edgeBot = [CC3PlaneNode nodeWithName: @"edgeBot"];
    edgeTop = [CC3PlaneNode nodeWithName: @"edgeTop"];
    edgeRight = [CC3PlaneNode nodeWithName: @"edgeRight"];
    edgeLeft = [CC3PlaneNode nodeWithName: @"edgeLeft"];

    [edgeBot populateAsCenteredRectangleWithSize: CGSizeMake(59.0, 5.0)
                                  withTexture: [CC3Texture textureFromFile: @"forcefield.png"]
                                invertTexture: NO ];
    [edgeTop populateAsCenteredRectangleWithSize: CGSizeMake(59.0, 5.0)
                                     withTexture: [CC3Texture textureFromFile: @"forcefield.png"]
                                   invertTexture: NO ];
    [edgeRight populateAsCenteredRectangleWithSize: CGSizeMake(17.5, 5.0)
                                     withTexture: [CC3Texture textureFromFile: @"forcefield.png"]
                                   invertTexture: NO ];
    [edgeLeft populateAsCenteredRectangleWithSize: CGSizeMake(17.5, 5.0)
                                     withTexture: [CC3Texture textureFromFile: @"forcefield.png"]
                                   invertTexture: NO ];
    edgeRight.isOpaque = NO;
    edgeRight.location = cc3v(30.0, 1.5, 0.0);
    
	edgeRight.rotation = cc3v(0.0, 0,90.0);
    [self addChild:edgeRight];
    
    edgeLeft.isOpaque = NO;
    edgeLeft.location = cc3v(-30.0, 1.5, 0.0);
    
	edgeLeft.rotation = cc3v(0.0, 0,90.0);
    [self addChild:edgeLeft];
    
    edgeTop.isOpaque = NO;
	edgeTop.rotation = cc3v(0, 0.0,0.0);
    [self addChild:edgeTop];
    
    edgeBot.isOpaque = NO;
	edgeBot.rotation = cc3v(0, 0.0,0.0);
    [self addChild:edgeBot];
    
    self.ambientLight = kCCC4FBlackTransparent;
	CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
	cam.location = cc3v( 00.0, 0.0, 000.0 );
	CC3Light* lamp = [CC3Light nodeWithName: @"Lamp"];
/*	lamp.location = cc3v( -20.0, 0.0, 0.0 );
	lamp.isDirectionalOnly = NO;
	[cam addChild: lamp];
	
	CC3Light* lamp2 = [CC3Light nodeWithName: @"Lamp2"];
	lamp2.location = cc3v( 20.0, 0.0, 0.0 );
	lamp2.isDirectionalOnly = NO;
	[cam addChild: lamp2];
	
	CC3Light* lamp3 = [CC3Light nodeWithName: @"Lamp3"];
	lamp3.location = cc3v( 0.0, 20.0, 0.0 );
	lamp3.isDirectionalOnly = NO;
	[cam addChild: lamp3];*/
	
    [boom addChild:cam];
    [self addChild:boom];
    self.asteroids = [NSMutableArray arrayWithCapacity:1];
    self.playerLasers = [NSMutableArray arrayWithCapacity:1];
//	self.enemyLasers = [NSMutableArray arrayWithCapacity:1];
    
	mapType = [[myDele fetchMapNum] intValue];
    NSNumber *tempMap = [myDele fetchMapNum];
    if([tempMap isKindOfClass:[NSNumber class]]) {
        mapType = [tempMap intValue];
    } else {
        NSNumber *tempMap2 = [myDele fetchMapNum];
        if([tempMap2 isKindOfClass:[NSNumber class]]) {
            mapType = [tempMap2 intValue];
        } else {
            mapType = 1;
        }
    }
    
	wall = [CC3PlaneNode nodeWithName: @"Wall1"];
    
    NSLog(@"Map: %d", mapType);
    if(mapType==1)
        [wall populateAsCenteredRectangleWithSize: CGSizeMake(400.0, 400.0)
                                      withTexture: [CC3Texture textureFromFile: @"bg1_p1.jpg"]
                                    invertTexture: YES ];
    
    else if(mapType==2)
        [wall populateAsCenteredRectangleWithSize: CGSizeMake(400.0, 400.0)
                                      withTexture: [CC3Texture textureFromFile: @"bg2_p1.png"]
                                    invertTexture: YES ];
    
    else if(mapType==3)
        [wall populateAsCenteredRectangleWithSize: CGSizeMake(400.0, 400.0)
                                      withTexture: [CC3Texture textureFromFile: @"bg3_p1.png"]
                                    invertTexture: YES ];
    
    else if(mapType==4) 
        [wall populateAsCenteredRectangleWithSize: CGSizeMake(400.0, 400.0)
                                      withTexture: [CC3Texture textureFromFile: @"bg4_p1.png"]
                                    invertTexture: YES ];
    

    if(mapType==1) scoreMod = 10*2*([diff intValue] + 1);
    else if(mapType==2) scoreMod = 10*([diff intValue] + 1);
    else if(mapType==3) scoreMod = 10/2*([diff intValue] + 1);
    else if(mapType==4) scoreMod = 10/2*([diff intValue] + 1);
    
    
    if(mapType==4)
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"explosion.wav"];
    else
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"collision.wav"];

	wall.location = cc3v(0.0, 0.0, -499.0);
	wall.rotation = cc3v(0.0, 00.0, 90.0);
	wall.shouldCullBackFaces = NO;
	wall.isTouchEnabled = NO;
	[wall retainVertexLocations];
	[self addChild: wall];
	[self createGLBuffers];
	[self releaseRedundantData];
	
	ship_wrap = [CC3Node nodeWithName: @"ship_wrap"];
    
    //VARIOUS SHIPS
    
    [self addContentFromPODResourceFile: @"alien_ship_1.pod"];
	playerShip = (CC3MeshNode*)[self getNodeNamed: @"alien_ship_1"];
    playerShip.rotation = cc3v(0,-90,0.0);
    
    //[self addContentFromPODResourceFile: @"ship2.pod"];
	//playerShip = (CC3MeshNode*)[self getNodeNamed: @"ship_2"];
    //playerShip.rotation = cc3v(-90,-90,0.0);
    
  //  [self addContentFromPODResourceFile: @"ship3.pod"];
	//playerShip = (CC3MeshNode*)[self getNodeNamed: @"ship_3"];
   // playerShip.rotation = cc3v(-90,-90,0.0);
    
    //[self addContentFromPODResourceFile: @"ship4.pod"];
	//playerShip = (CC3MeshNode*)[self getNodeNamed: @"ship_4"];
    //playerShip.rotation = cc3v(90,-90,0.0);
    
    //[self addContentFromPODResourceFile: @"ship5.pod"];
	//playerShip = (CC3MeshNode*)[self getNodeNamed: @"ship_5"];
    //playerShip.rotation = cc3v(-90,-90,0.0);
    
    //[self addContentFromPODResourceFile: @"ship6.pod"];
	//playerShip = (CC3MeshNode*)[self getNodeNamed: @"ship_6"];
   // playerShip.rotation = cc3v(-90,-90,0.0);
    
  //  [self addContentFromPODResourceFile: @"ship7.pod"];
	//playerShip = (CC3MeshNode*)[self getNodeNamed: @"ship_7"];
   // playerShip.rotation = cc3v(-90,-90,0.0);
    
    CCArray* bvs = ((CC3NodeTighteningBoundingVolumeSequence*)playerShip.boundingVolume).boundingVolumes;
    [bvs removeObjectAtIndex:1];
    NSLog(@"%@", bvs);
	CC3NodeSphericalBoundingVolume* sbv = [bvs objectAtIndex: 0];
	sbv.radius = sbv.radius/3.0;
    
	[ship_wrap addChild:playerShip];
	ship_wrap.location = cc3v(0.0, -3.0, -35.0 );
    [cam addChild:ship_wrap];

    
    //Engine burn emitter
    CC3PointParticleVertexContent particleContent = kCC3PointParticleContentColor |
    kCC3PointParticleContentSize;
	CC3VariegatedPointParticleHoseEmitter* emitter = [CC3VariegatedPointParticleHoseEmitter nodeWithName: @"emitter_fire"];
	[emitter populateForMaxParticles: 150 containing: particleContent];
	emitter.texture = [CC3Texture textureFromFile: @"fire.png"];
	emitter.emissionRate = 50.0f;
	emitter.minParticleLifeSpan = 0.5f;
	emitter.maxParticleLifeSpan = 1.0f;
	emitter.minParticleSpeed = 3.0f;
	emitter.maxParticleSpeed = 5.0f;
	emitter.minParticleStartingSize = 1.2f;
	emitter.maxParticleStartingSize = 1.8f;
	emitter.minParticleEndingSize = kCC3ParticleConstantSize;
	emitter.maxParticleEndingSize = kCC3ParticleConstantSize;
	emitter.minParticleStartingColor = kCCC4FRed;
	emitter.maxParticleStartingColor = kCCC4FYellow;	
	emitter.minParticleEndingColor = kCC3ParticleFadeOut;
	emitter.maxParticleEndingColor = kCC3ParticleFadeOut;
	emitter.dispersionAngle = CGSizeMake(20.0, 20.0);
    emitter.nozzle.rotation = cc3v(0,-180,0);
    emitter.nozzle.location = cc3v(0,0,3);
	emitter.shouldPrecalculateNozzleTangents = NO;
	emitter.unityScaleDistance = 200.0;
    emitter.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};
	emitter.boundingVolumePadding = 20.0;
	emitter.shouldDrawLocalContentWireframeBox = NO;
	emitter.isTouchEnabled = NO;

    [ship_wrap addChild:emitter.nozzle];
    [ship_wrap addChild:emitter];
    [emitter play];

    
    CCActionInterval* partialMove = [CC3MoveBy actionWithDuration: 1.0
														   moveBy: cc3v(0, 0,-150)];
    
	[boom runAction: [CCRepeatForever actionWithAction: partialMove]];
    
    [self loadPODData];
}
    @catch (NSException * e) {
        myDele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
        [myDele startGame:[myDele fetchMapNum]];
        return;
    }
    
}

-(void)loadPODData {
   [self addContentFromPODResourceFile: @"laser.pod"];
    if(mapType == 4) [self addContentFromPODResourceFile: @"mine.pod"];
    else if (mapType == 2) {
        [self addContentFromPODResourceFile: @"gem1.pod"];
        [self addContentFromPODResourceFile: @"gem2.pod"];
        [self addContentFromPODResourceFile: @"crystal_1.pod"];
    } else if (mapType == 3) {
        [self addContentFromPODResourceFile: @"remains1.pod"];
        [self addContentFromPODResourceFile: @"remains2.pod"];
        [self addContentFromPODResourceFile: @"remains3.pod"];
    }  else  {
        [self addContentFromPODResourceFile: @"rock1.pod"];
        [self addContentFromPODResourceFile: @"rock2.pod"];
        [self addContentFromPODResourceFile: @"rock3.pod"];
        [self addContentFromPODResourceFile: @"rock4.pod"];
    }

}

#pragma mark Updating custom activity

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the 3D nodes in the scene.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {
    
    
    //Spawn Asteroid
    if(spawn_counter>=asteroid_spawn_rate) {
        [self spawnAsteroid];
        spawn_counter = 0;
    } else {
        spawn_counter++;
    }
    
    //Move world with ship
    CC3Node *boomAsNode = (CC3Node *)boom;
    
    CC3Vector wallLoc = cc3v(boomAsNode.location.x, boomAsNode.location.y, -499.0+boomAsNode.location.z);
    
    CC3MoveTo *move = [CC3MoveTo actionWithDuration:0.1 moveTo:cc3v(29.0,1.5,ship_wrap.globalLocation.z-5)];
    [edgeRight runAction:move];
    
    move = [CC3MoveTo actionWithDuration:0.1 moveTo:cc3v(-29.0,1.5,ship_wrap.globalLocation.z-5)];
    [edgeLeft runAction:move];
    
    move = [CC3MoveTo actionWithDuration:0.1 moveTo:cc3v(0.0, 10, ship_wrap.globalLocation.z-5)];
    [edgeTop runAction:move];
    
    move = [CC3MoveTo actionWithDuration:0.1 moveTo:cc3v(0.0, -7, ship_wrap.globalLocation.z-5)];
    [edgeBot runAction:move];
    
    [self movePlane:wall :wallLoc];
    
	

}

-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {
    if(isDead) return;
    
    

    NSMutableArray *temp = [NSMutableArray arrayWithArray:asteroids];
    if(timer==1) {
        [self endcollsion];
    }
    if(timer>0) {
        timer--;
    }
    
    for(CC3MeshNode *roid in temp) {
       // if(roid.globalLocation.z-playerShip.globalLocation.z < 20) {
        
        for(CC3MeshNode *laser in self.playerLasers) {
            if([laser doesIntersectBoundingVolume:roid.boundingVolume]) {
                
                if(laserDamage<[roid.health floatValue]) {
                    roid.health = [NSNumber numberWithFloat:([roid.health floatValue]-laserDamage)];
                }
                else {
                    CC3PointParticleVertexContent particleContent = kCC3PointParticleContentColor |
                    kCC3PointParticleContentSize;
                    
                    collisionEmitter= [CC3VariegatedPointParticleHoseEmitter nodeWithName: @"emitter_fire"];
                    [collisionEmitter populateForMaxParticles: 500 containing: particleContent];
                    collisionEmitter.texture = [CC3Texture textureFromFile: @"fire.png"];
                    collisionEmitter.emissionRate = 500.0f;
                    collisionEmitter.minParticleLifeSpan = 0.3f;
                    collisionEmitter.maxParticleLifeSpan = 0.6f;
                    collisionEmitter.minParticleSpeed = 20.0f;
                    collisionEmitter.maxParticleSpeed = 50.0f;
                    collisionEmitter.minParticleStartingSize = 2.0f;
                    collisionEmitter.maxParticleStartingSize = 6.0f;
                    collisionEmitter.minParticleEndingSize = kCC3ParticleConstantSize;
                    collisionEmitter.maxParticleEndingSize = kCC3ParticleConstantSize;
                    collisionEmitter.minParticleStartingColor = kCCC4FRed;
                    collisionEmitter.maxParticleStartingColor = kCCC4FYellow;
                    collisionEmitter.minParticleEndingColor = kCCC4FDarkGray;
                    collisionEmitter.maxParticleEndingColor = kCCC4FLightGray;
                    collisionEmitter.dispersionAngle = CGSizeMake(780.0, 780.0);
                    collisionEmitter.shouldPrecalculateNozzleTangents = NO;
                    collisionEmitter.unityScaleDistance = 200.0;
                    collisionEmitter.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};
                    collisionEmitter.boundingVolumePadding = 20.0;
                    collisionEmitter.shouldDrawLocalContentWireframeBox = NO;
                    collisionEmitter.isTouchEnabled = NO;
                    
                    CC3Node *emitterNode = [CC3Node node];
                    emitterNode.location = roid.globalLocation;
                    [emitterNode addChild:collisionEmitter];
                    [emitterNode addChild:collisionEmitter.nozzle];
                    [self addChild:emitterNode];
                    [collisionEmitter play];
                    [asteroids removeObject:roid];
                    [self removeChild:roid];
                    
                    if(soundEnabled) {
                        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                        [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];
                    }
                }
            }
        }
        
            if([playerShip doesIntersectBoundingVolume:roid.boundingVolume]) {

            playerShipHealth -= roid_ship_damage;
            if(playerShipHealth > 0) {
                
                [myDele updateHealth:[NSNumber numberWithFloat:playerShipHealth]];
                
                if(mapType==4) {
                    CC3PointParticleVertexContent particleContent = kCC3PointParticleContentColor |
                    kCC3PointParticleContentSize;

                    collisionEmitter= [CC3VariegatedPointParticleHoseEmitter nodeWithName: @"emitter_fire"];
                    [collisionEmitter populateForMaxParticles: 500 containing: particleContent];
                    collisionEmitter.texture = [CC3Texture textureFromFile: @"fire.png"];
                    collisionEmitter.emissionRate = 500.0f;
                    collisionEmitter.minParticleLifeSpan = 0.3f;
                    collisionEmitter.maxParticleLifeSpan = 0.6f;
                    collisionEmitter.minParticleSpeed = 20.0f;
                    collisionEmitter.maxParticleSpeed = 50.0f;		
                    collisionEmitter.minParticleStartingSize = 1.0f;
                    collisionEmitter.maxParticleStartingSize = 2.0f;
                    collisionEmitter.minParticleEndingSize = kCC3ParticleConstantSize;
                    collisionEmitter.maxParticleEndingSize = kCC3ParticleConstantSize;
                    collisionEmitter.minParticleStartingColor = kCCC4FRed;
                    collisionEmitter.maxParticleStartingColor = kCCC4FYellow;		
                    collisionEmitter.minParticleEndingColor = kCCC4FDarkGray;
                    collisionEmitter.maxParticleEndingColor = kCC3ParticleFadeOut;	
                    collisionEmitter.dispersionAngle = CGSizeMake(780.0, 780.0);
                    collisionEmitter.shouldPrecalculateNozzleTangents = NO;
                    collisionEmitter.unityScaleDistance = 200.0;
                    collisionEmitter.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};
                    collisionEmitter.boundingVolumePadding = 20.0;
                    collisionEmitter.shouldDrawLocalContentWireframeBox = NO;
                    collisionEmitter.isTouchEnabled = NO;
 
                    CC3Node *emitterNode = [CC3Node node];
                    emitterNode.location = roid.globalLocation;
                    [emitterNode addChild:collisionEmitter];
                    [emitterNode addChild:collisionEmitter.nozzle];
                    [self addChild:emitterNode];
                    [collisionEmitter play];
                    [asteroids removeObject:roid];
                    [self removeChild:roid];
                    if(soundEnabled) {
                            AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                        [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];
                    }
                    
                    timer = 20;
                } else {
                
                    CCActionInterval *roidRotate = [CC3RotateToLookAt actionWithDuration:0.5 targetLocation:cc3v([self getRandomNumber:0 to:360], [self getRandomNumber:0 to:360], [self getRandomNumber:0 to:360])];
                    [roid runAction:roidRotate];
                    
                    if(roid.globalLocation.x > playerShip.globalLocation.x) {
                        CCActionInterval *roidMove = [CC3MoveBy actionWithDuration:1.0 moveBy:cc3v(14.0,[self getRandomNumber:-10 to:10],0)];
                        [roid runAction:roidMove];
                        
                    } else {
                        
                        CCActionInterval *roidMove = [CC3MoveBy actionWithDuration:1.0 moveBy:cc3v(-14.0,[self getRandomNumber:-10 to:10],0)];
                        [roid runAction:roidMove];
                    }
                    CC3PointParticleVertexContent particleContent = kCC3PointParticleContentColor |
                    kCC3PointParticleContentSize;
                    
                    collisionEmitter= [CC3VariegatedPointParticleHoseEmitter nodeWithName: @"emitter_fire"];
                    [collisionEmitter populateForMaxParticles: 800 containing: particleContent];

                    collisionEmitter.texture = [CC3Texture textureFromFile: @"fire.png"];
                    collisionEmitter.emissionRate = 800.0f;	
                    collisionEmitter.minParticleLifeSpan = 0.5f;
                    collisionEmitter.maxParticleLifeSpan = 1.0f;						
                    collisionEmitter.minParticleSpeed = 50.0f;
                    collisionEmitter.maxParticleSpeed = 700.0f;		
                    collisionEmitter.minParticleStartingSize = 0.8f;
                    collisionEmitter.maxParticleStartingSize = 1.6f;
                    collisionEmitter.minParticleEndingSize = kCC3ParticleConstantSize;
                    collisionEmitter.maxParticleEndingSize = kCC3ParticleConstantSize;	
                    collisionEmitter.minParticleStartingColor = kCCC4FRed;
                    collisionEmitter.maxParticleStartingColor = kCCC4FYellow;	
                    collisionEmitter.minParticleEndingColor = kCC3ParticleFadeOut;
                    collisionEmitter.maxParticleEndingColor = kCC3ParticleFadeOut;
                    collisionEmitter.dispersionAngle = CGSizeMake(780.0, 780.0);

                    collisionEmitter.shouldPrecalculateNozzleTangents = NO;
                    collisionEmitter.unityScaleDistance = 200.0;
                    collisionEmitter.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};
                    collisionEmitter.boundingVolumePadding = 20.0;
                    collisionEmitter.shouldDrawLocalContentWireframeBox = NO;
                    collisionEmitter.isTouchEnabled = NO;

                    
                    CC3Node *emitterNode = [CC3Node node];
                    [emitterNode addChild:collisionEmitter];
                    [emitterNode addChild:collisionEmitter.nozzle];
                    collisionEmitter.nozzle.rotation = cc3v(0,-90,0);
                    [collisionEmitter play];
                    [playerShip addChild:emitterNode];
                    
                    if(soundEnabled)  {
                        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                        [[SimpleAudioEngine sharedEngine]playEffect:@"collision.wav"];
                    }
                    
                    timer = 20;
                }
                
                
            } else {
                if(mapType !=4) {
                    CCActionInterval *roidRotate = [CC3RotateToLookAt actionWithDuration:1.0 targetLocation:cc3v([self getRandomNumber:0 to:360], [self getRandomNumber:0 to:360], [self getRandomNumber:0 to:360])];
                    [roid runAction:roidRotate];
                    
                    if(roid.globalLocation.x > playerShip.globalLocation.x) {
                        CCActionInterval *roidMove = [CC3MoveBy actionWithDuration:1.0 moveBy:cc3v(14.0,[self getRandomNumber:-10 to:10],0)];
                        [roid runAction:roidMove];
                        
                    } else {
                        
                        CCActionInterval *roidMove = [CC3MoveBy actionWithDuration:1.0 moveBy:cc3v(-14.0,[self getRandomNumber:-10 to:10],0)];
                        [roid runAction:roidMove];
                    }
                    if(soundEnabled)  {
                        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                        [[SimpleAudioEngine sharedEngine]playEffect:@"collision.wav"];
                    }
                    
                } else {
                    [asteroids removeObject:roid];
                    [self removeChild:roid];
                    if(soundEnabled) {
                        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
                        [[SimpleAudioEngine sharedEngine] playEffect:@"explosion.wav"];
                    }
                }
                
                NSLog(@"Death");
                [myDele updateHealth:[NSNumber numberWithFloat:0.0]];
                [self killAnimation];
            }
                [asteroids removeObject:roid];

        }
            
//}
    if (playerShip.globalLocation.z+35< roid.globalLocation.z) {
        
        [myDele updateScore:[NSNumber numberWithInt:scoreMod]];
        [asteroids removeObject:roid];
        [self removeChild:roid];
    }
    
    }

}

 -(void)endcollsion {
         [collisionEmitter stop];
         [playerShip removeChild:collisionEmitter.nozzle];
         [playerShip removeChild:collisionEmitter];
 }

-(void)killEmitter {
    [collisionEmitter stop];
    CC3Node *roid = (CC3Node *)[collisionEmitter parent];
    [roid removeChild:[collisionEmitter nozzle]];
    [roid removeChild:collisionEmitter];
    [self removeChild:roid];
    
}

#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {
    
	// Uncomment this line to have the camera move to show the entire scene.
	// This must be done after the CC3Layer has been attached to the view,
	// because this makes use of the camera frustum and projection.
    //	[self.activeCamera moveWithDuration: 3.0 toShowAllOf: self];
    
	// Uncomment this line to draw the bounding box of the scene.
    //	self.shouldDrawWireframeBox = YES;
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


#pragma mark Handling touch events

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touch events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint {}

/**
 * This callback template method is invoked automatically when a node has been picked
 * by the invocation of the pickNodeFromTapAt: or pickNodeFromTouchEvent:at: methods,
 * as a result of a touch event or tap gesture.
 *
 * Override this method to perform activities on 3D nodes that have been picked by the user.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {}



-(void) accelTurn:(UIAcceleration*)acceleration
{
    if(isDead)return;
    
    
    
    
	if(!orientated){
        vert = FALSE;
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if([[prefs valueForKey:@"orient"] isEqualToString:@"flat"]) {
            baseAccelY = 0;
        } else if ([[prefs valueForKey:@"orient"] isEqualToString:@"vert"]) {
           baseAccelY = 1;
            vert = TRUE;
        } else {
            baseAccelY = 0.5;
        }

		orientated = TRUE;
	}

    
    
    
    float modAccelX;

    
    

    GLfloat maxX = 25.0;
    GLfloat minX = -25.0;
    float accelForY;

    if(boom.globalLocation.x<minX) {
        if(boom.globalLocation.x<minX-1) accelForY = -0.15*-100;
        else if(acceleration.y>0) accelForY = 0;
        else accelForY = acceleration.y*-160;
    } else if(boom.globalLocation.x>maxX) {
        if(boom.globalLocation.x>maxX+1) accelForY = 0.15*-100;
        else if(acceleration.y<0)  accelForY = 0;
        else accelForY = acceleration.y*-160;
    } else {
        accelForY = acceleration.y*-160;
    }
    
    int mod = 1;
    
    if(vert) {
        if(acceleration.z >0) {
            mod = -1;
        }
    }

    if(boom.globalLocation.y<-2.0f) {
        if(boom.globalLocation.y<-3.0f) modAccelX = -0.1*-100;
        else if((acceleration.x + baseAccelY)*(invert*-1)*mod >0) modAccelX = 0;
        else modAccelX = (acceleration.x + baseAccelY)*invert*mod*100;
    } else if(boom.globalLocation.y>10.0f) {
        if(boom.globalLocation.y>11.0f) modAccelX = 0.1*-100;
        else if((acceleration.x + baseAccelY)*mod*(invert*-1) <0) modAccelX = 0;
        else modAccelX = (acceleration.x + baseAccelY)*mod*invert*100;
    } else {
        modAccelX = (acceleration.x + baseAccelY)*mod*invert*100;
    }
    
   
    CCActionInterval* partialRot = [CC3RotateTo actionWithDuration: 0.2
														   rotateTo:cc3v(modAccelX,0.0,-accelForY)];
    [ship_wrap runAction:partialRot];
    
	CCActionInterval* partialMove = [CC3MoveBy actionWithDuration: 1.0
														   moveBy: cc3v(accelForY, modAccelX,-150)];
    
	[boom runAction: [CCRepeatForever actionWithAction: partialMove]];
    
}

-(void)reOrient {
    orientated = FALSE;
}

-(void)movePlane:(CC3Node*) node :(CC3Vector)loc {
    //CC3MoveTo *smoothMove = [CC3MoveTo actionWithDuration:0.1 moveTo:loc];
    //[node runAction:smoothMove];
    
    node.location =loc;
}

-(BOOL)checkCollision :(CC3Vector)obj1Max :(CC3Vector)obj1Min :(CC3Vector)obj2Max :(CC3Vector)obj2Min {
	if((obj1Max.x<obj2Max.x&&obj1Max.y<obj2Max.y&&obj1Max.z<obj2Max.z)&&(obj1Min.x>obj2Min.x&&obj1Min.y>obj2Min.y&&obj1Min.z>obj2Min.z)) {
        NSLog(@"Hit!");
		return TRUE;
	}
	return FALSE;
}

-(void)killAnimation {
    NSLog(@"Kill Ani Running");
    isDead = TRUE;

	CC3PointParticleVertexContent particleContent = kCC3PointParticleContentColor |
    kCC3PointParticleContentSize;
	
	deathEmitter = [CC3VariegatedPointParticleHoseEmitter nodeWithName: @"emitter_fire"];
	[deathEmitter populateForMaxParticles: 1000 containing: particleContent];
	deathEmitter.texture = [CC3Texture textureFromFile: @"fire.png"];
	deathEmitter.emissionRate = 600.0f;			
	deathEmitter.minParticleLifeSpan = 0.5f;
	deathEmitter.maxParticleLifeSpan = 1.0f;		
	deathEmitter.minParticleSpeed = 90.0f;
	deathEmitter.maxParticleSpeed = 150.0f;	
	deathEmitter.minParticleStartingSize = 1.0f;
	deathEmitter.maxParticleStartingSize = 1.8f;
	deathEmitter.minParticleEndingSize = kCC3ParticleConstantSize;
	deathEmitter.maxParticleEndingSize = kCC3ParticleConstantSize;
	deathEmitter.minParticleStartingColor = kCCC4FRed;
	deathEmitter.maxParticleStartingColor = kCCC4FYellow;
	deathEmitter.minParticleEndingColor = kCC3ParticleFadeOut;
	deathEmitter.maxParticleEndingColor = kCC3ParticleFadeOut;
	deathEmitter.dispersionAngle = CGSizeMake(360.0, 360.0);
	deathEmitter.shouldPrecalculateNozzleTangents = NO;

	deathEmitter.unityScaleDistance = 200.0;
    deathEmitter.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};
	deathEmitter.boundingVolumePadding = 20.0;
	deathEmitter.shouldDrawLocalContentWireframeBox = NO;
	deathEmitter.isTouchEnabled = NO;
    deathEmitter.nozzle.rotation = cc3v(0,-90,0);
    [playerShip addChild:deathEmitter.nozzle];
    [playerShip addChild:deathEmitter];
    [deathEmitter play];
    

    [self performSelector:@selector(finishDeathSequence:) withObject:nil afterDelay:1.0];
    CCActionInterval* partialMove = [CC3MoveBy actionWithDuration: 1.5
														   moveBy: cc3v(0.0, 10.0, 30.0)];
	[boom runAction: [CCRepeatForever actionWithAction: partialMove]];
    [boom stopAllActions];
    CCActionInterval* partialMove2 = [CC3MoveBy actionWithDuration: 1.5
														   moveBy: cc3v(0.0, -10.0, -30.0)];
	[ship_wrap runAction: [CCRepeatForever actionWithAction: partialMove2]];
}

-(void)finishDeathSequence:(id)sender {
    NSLog(@"Finish Death Sequence");
    [deathEmitter stop];
    asteroids = nil;
    [self stopAllActions];
     NSLog(@"Actions Stopped");
    [myDele playerKilled];
}

-(void)doCleanup {
    [activeCamera removeAllChildren];
    activeCamera = nil;
    [self removeAllChildren];
    
}


-(void)createSparks :(CC3Vector)hitLocation :(CC3TargettingNode*) ship_wrap {

	CC3PointParticleVertexContent particleContent = kCC3PointParticleContentColor |
    kCC3PointParticleContentSize;
	

	CC3VariegatedPointParticleHoseEmitter* emitter = [CC3VariegatedPointParticleHoseEmitter nodeWithName: @"emitter_fire"];
	[emitter populateForMaxParticles: 150 containing: particleContent];
	
	emitter.texture = [CC3Texture textureFromFile: @"fire.png"];
	emitter.emissionRate = 150.0f;
	emitter.minParticleLifeSpan = 0.5f;
	emitter.maxParticleLifeSpan = 1.0f;
	emitter.minParticleSpeed = 3.0f;
	emitter.maxParticleSpeed = 5.0f;
	emitter.minParticleStartingSize = 0.8f;
	emitter.maxParticleStartingSize = 1.3f;
	emitter.minParticleEndingSize = kCC3ParticleConstantSize;
	emitter.maxParticleEndingSize = kCC3ParticleConstantSize;
	emitter.minParticleStartingColor = kCCC4FRed;
	emitter.maxParticleStartingColor = kCCC4FYellow;
	emitter.minParticleEndingColor = kCC3ParticleFadeOut;
	emitter.maxParticleEndingColor = kCC3ParticleFadeOut;

	emitter.dispersionAngle = CGSizeMake(360.0, 360.0);
	emitter.shouldPrecalculateNozzleTangents = NO;
	emitter.unityScaleDistance = 200.0;

	emitter.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA};

	emitter.boundingVolumePadding = 20.0;

	emitter.shouldDrawLocalContentWireframeBox = NO;
    
	emitter.isTouchEnabled = NO;

    [ship_wrap addChild:emitter.nozzle];
    [ship_wrap addChild:emitter];
    [emitter play];

    
    
}


-(void)createSpark :(CC3Vector)loc :(CC3Vector)endloc {
    CCSprite *sparkSprite = [CCSprite spriteWithFile:@"spark_trans.png"];

    CC3Billboard* spark = [CC3Billboard nodeWithName:@"spark_board" withBillboard:sparkSprite];

    spark.location = loc;
    CCSequence *sequence = [CCSequence actions:
                            [CC3MoveTo actionWithDuration: 0.5
                                                   moveTo: endloc],
                            [CCCallFuncN actionWithTarget:self selector:@selector(afterSparkAnimation:)],
                            nil];
    
    
    
    [spark runAction: sequence];
    [self addChild:spark];
    
}

-(void)fireLaser {
    
    //***************************
    // OPTIONALLY ENABLE SHOOTING LASERS
    
    /*CCSprite *laserSprite = [[CCSprite alloc] initWithFile:@"laser_text.png"];
    
    
    CC3Billboard *laser = [[CC3Billboard alloc] initWithName:@"laser_board" withBillboard:laserSprite];
    
    [laser setLocation:cc3v(0.0,0.0,0.0)];
    CGRect rect = [laser billboardBoundingRect];
    
    [playerShip addChild:laser];
    
	//[activeCamera addChild:laser];
    [laserSprite release];
    [laser release];
	if(shotAlernator%2==0) {
		laser.location = cc3v(0.4,0,0);
		shotAlernator = 0;
        
	} else {
		laser.location = cc3v(-0.4,0,0);
	}
	shotAlernator++;
    
    
    CCSequence *sequence = [CCSequence actions:
                            [CC3MoveTo actionWithDuration: 1.0
                                                   moveTo: cc3v(0.0,0.0,-800.0)],
                            [CCCallFuncN actionWithTarget:self selector:@selector(afterAnimation:)],
                            nil];
    
    
    [laser runAction: sequence];//[CCRepeatForever actionWithAction: laserMove]];
//	[playerLasers addObject:laser];
    /*[activeCamera removeChild:transBill];
     [transSprite release];
     [transBill release];*/
//	NSLog(@"Shots %i", [playerLasers count]);
    
    /*
    if(!canFire) return;
    CC3MeshNode* laser;
    laser = (CC3MeshNode*)[[self getNodeNamed: @"laser"] copy];
    
    [laser setLocation:cc3v(ship_wrap.globalLocation.x,ship_wrap.globalLocation.y-0.25,ship_wrap.globalLocation.z-7)];
   // [ship_wrap addChild:laser];
  //  CCSequence *sequence = [CCSequence actions:
  //                          [CC3MoveTo actionWithDuration: 2.0
  //                                                 moveTo: cc3v(0.0,0.0,-600.0)],
   //                         [CCCallFuncN actionWithTarget:self /selector:@selector(afterLaserAnimation:)],
    //                        nil];
    CCSequence *sequence = [CCSequence actions: [CC3MoveBy actionWithDuration:2.0 moveBy:cc3v(ship_wrap.globalForwardDirection.x*600,ship_wrap.globalForwardDirection.y*600,ship_wrap.globalForwardDirection.z*600)],
    [CCCallFuncN actionWithTarget:self selector:@selector(afterLaserAnimation:)],
    nil];
    [laser runAction:sequence];
    [self.playerLasers addObject:laser];
	[self addChild:laser];
	NSLog(@"PEW PEW PEW");
    canFire = FALSE;
    [myDele createWeaponsTimer];*/

}

-(void)spawnAsteroid {
    //Add an asteroid
    CC3MeshNode* asteroid;
    if(mapType == 4) {
        asteroid = (CC3MeshNode*)[[self getNodeNamed: @"mine"] copy];
        [asteroid setHealth:[NSNumber numberWithInt:20]];
    } else if (mapType == 2) {
        int x = arc4random() % 3;
        if(x==0) {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"gem1"] copy];
            [asteroid setHealth:[NSNumber numberWithInt:120]];
        }
        else if(x==1) {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"gem2"] copy];
            [asteroid setHealth:[NSNumber numberWithInt:120]];
        }
        else {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"crystal_1"] copy];
            [asteroid setHealth:[NSNumber numberWithInt:60]];
        }
    } else if (mapType == 3) {
        int x = arc4random() % 3;
        if(x==0) {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"remains1"] copy];
             [asteroid setHealth:[NSNumber numberWithInt:30]];
        }
        else if(x==1) {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"remains2"] copy];
             [asteroid setHealth:[NSNumber numberWithInt:30]];
        }
        else {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"remains3"] copy];
             [asteroid setHealth:[NSNumber numberWithInt:30]];
        }
    } else {
        int x = arc4random() % 4;

        if(x==0) {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"Asteroid"] copy];
            [asteroid setHealth:[NSNumber numberWithInt:120]];
        }
        else if(x == 1) {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"Asteroid2"] copy];
            [asteroid setHealth:[NSNumber numberWithInt:10]];
        }
        else if(x == 2) {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"Asteroid3"] copy];
            [asteroid setHealth:[NSNumber numberWithInt:30]];
        }
        else {
            asteroid = (CC3MeshNode*)[[self getNodeNamed: @"Asteroid4"] copy];
            [asteroid setHealth:[NSNumber numberWithInt:60]];
        }
    }


     
    CCArray* bvs = ((CC3NodeTighteningBoundingVolumeSequence*)asteroid.boundingVolume).boundingVolumes;
    CC3NodeSphericalBoundingVolume* sbv = [bvs objectAtIndex: 0];
	sbv.radius = [sbv radius]/2.6;
    [bvs removeObjectAtIndex:1];
    
    //asteroid.shouldDrawAllBoundingVolumes = NO;
    //asteroid.opacity = 0;
 
    
   
    int newPop = [self getRandomNumber:-28 to:28];
    
    if(newPop - lastPop < 6 && newPop - lastPop > -6) {
        if(newPop > lastPop) {
            newPop += 6;
        } else {
            newPop += -6;
        }
    }
    
    lastPop = newPop;
    
    int randLoc = [self getRandomNumber:-8 to:8];
    
    int rand = [self getRandomNumber:-180 to:180];
    int rand2 = [self getRandomNumber:-180 to:180];
    int rand3 = [self getRandomNumber:-180 to:180];
    asteroid.rotation = cc3v(rand,rand2,rand3);
   // CC3RotateBy *rot = [CC3RotateBy actionWithDuration:1.0 rotateBy:cc3v(rand, rand,[self getRandomNumber:-10 to:10])];
   // [asteroid runAction:[CCRepeatForever actionWithAction: rot]];
    
    asteroid.location = cc3v(lastPop,randLoc,activeCamera.globalLocation.z-350);
    [asteroids addObject:asteroid];
    
    //[asteroid setOpacity:0];
   // CCAc *fade = [CCFadeIn actionWithDuration:1.0];
   // CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:2.0 opacity:255];
   // CCActionInstant *fade = [CCFadeIn actionWithDuration:1.0];
   // [asteroid runAction:fadeTo];
    
    [self addChild:asteroid];
}

-(int)getRandomNumber:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

-(void)bounce :(CC3TargettingNode*)obj1 :(CC3TargettingNode*)obj2 :obj1Bounce :obj2Bounce{
    NSLog(@"Bounce");
}

-(void)afterLaserAnimation:(CC3Node *)sender
{
    [self.playerLasers removeObject:sender];
    [[sender parent] removeChild:sender];
 //   [playerLasers removeObject:sender];
    //    [sender release];
}

-(void)afterSparkAnimation:(id)sender
{
    
    [self removeChild:sender];
}

@end

#pragma mark -
#pragma mark HangingParticle

@implementation HangingParticle

-(void) initializeParticle {
	GLint zIndex = index / kParticlesPerSide;
	GLint xIndex = index % kParticlesPerSide;
    GLint yIndex = index / kParticlesPerSide;
	
	GLfloat xStart = -kParticlesPerSide * kParticlesSpacing / 2.0f;
	GLfloat zStart = -kParticlesPerSide * kParticlesSpacing / 2.0f;
    GLfloat yStart = -kParticlesPerSide * kParticlesSpacing / 2.0f;
	
	self.location = cc3v(xStart + (xIndex * kParticlesSpacing),
						 yStart + (yIndex * kParticlesSpacing),
						 zStart + (zIndex * kParticlesSpacing) );
	
	self.color4F = RandomCCC4FBetween(kCCC4FRed, kCCC4FYellow);
	
	GLfloat avgSize = emitter.particleSize;
	self.size = CC3RandomFloatBetween(avgSize * 0.05, avgSize * 0.25);
    
}

@end

