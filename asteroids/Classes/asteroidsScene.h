/**
 *  asteroidsScene.h
 *  asteroids
 *
 *  Created by Eric Schmitt on 9/20/12.
 *  Copyright __MyCompanyName__ 2012. All rights reserved.
 */


#import "CC3Scene.h"
#import "CC3MeshNode.h"
#import "CC3Billboard.h"
#import "CC3PointParticles.h"
#import "CC3PointParticleSamples.h"
#import "asteroidsAppDelegate.h"
#include "SimpleAudioEngine.h"


/** A sample application-specific CC3Scene subclass.*/
@interface asteroidsScene : CC3Scene {
    
    asteroidsAppDelegate *myDele;
    
	bool orientated;
	float baseAccelY;
	float baseAccelZ;
	CC3Vector *position;
	float currentRotationZ;
	float currentRotationY;
	float currentRotationX;
	int tracker;
	float player_ship_size;

    float asteroid_spawn_rate;
    int spawn_counter;
    float laser_size;
	NSMutableArray *asteroids;
	BOOL firstShot;
	int shotAlernator;
    int bounceMultiplier;
    int enemyBounceMultiplier;
    int mapType;
    NSNumber *shipAccelMod;
    CC3Billboard *locater;

    CC3PlaneNode* wall;

    NSMutableArray *playerLasers;
    
    CC3Node *boom;
    CC3MeshNode* cambox;
    CC3MeshNode* playerShip;
    CC3Node* ship_wrap;
    
    float enemyShipHealth;
    float playerShipHealth;
    float laserDamage;
    float roid_ship_damage;
    
    NSNumber *diff;

    double playershots;
    
    BOOL enemyCanFire;
    BOOL soundEnabled;
    BOOL vert;
    int invert;
    
    int timer;
    
    int scoreMod;
    
    CC3VariegatedPointParticleHoseEmitter* deathEmitter;
    
     CC3VariegatedPointParticleHoseEmitter* collisionEmitter;
    
    BOOL isDead;
    int lastPop;
    
    int score;
    
    BOOL *canFire;
    
    CC3PlaneNode* edgeTop;
    CC3PlaneNode* edgeBot;
    CC3PlaneNode* edgeRight;
    CC3PlaneNode* edgeLeft;
    
}


@property BOOL *canFire;
@property (nonatomic, retain) NSMutableArray *asteroids;
@property (nonatomic, retain) NSMutableArray *playerLasers;
//@property (nonatomic, retain) NSMutableArray *enemyLasers;

@property (nonatomic, retain) CC3PlaneNode* wall;
@property (nonatomic, retain) CC3PlaneNode* edgeTop;
@property (nonatomic, retain) CC3PlaneNode* edgeBot;
@property (nonatomic, retain) CC3PlaneNode* edgeRight;
@property (nonatomic, retain) CC3PlaneNode* edgeLeft;

@property (nonatomic, retain) CC3Node* boom;
@property (nonatomic, retain) NSNumber *shipAccelMod;
@property (nonatomic, retain) NSNumber *diff;


-(void)endcollsion;
-(void)doCleanup;
-(void)accelTurn:(UIAcceleration*)acceleration;
-(void)fireLaser;
-(void)reOrient;
-(void)finishDeathSequence:(id)sender;
-(void)configureToDiff:(NSNumber *)pd;
-(void)configureToMapType:(NSNumber *)pd;
-(int)getRandomNumber:(int)from to:(int)to;
-(void)killEmitter;
-(void)weaponFree;

@end

#pragma mark -
#pragma mark HangingParticle

#define kParticlesPerSide		30
#define kParticlesSpacing		1

/**
 * A particle type that simply hangs where it is located. When the particle is
 * initialized, the location is set from the index, so that the particles are
 * laid out in a simple rectangular grid in the X-Z plane, with kParticlesPerSide
 * particles on each side of the grid. This particle type contains no additional
 * state information.
 */
@interface HangingParticle : CC3PointParticle
@end
