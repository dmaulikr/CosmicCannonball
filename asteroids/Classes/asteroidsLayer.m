/**
 *  asteroidsLayer.m
 *  asteroids
 *
 *  Created by Eric Schmitt on 9/20/12.
 *  Copyright __MyCompanyName__ 2012. All rights reserved.
 */

#import "asteroidsLayer.h"
#import "asteroidsScene.h"
#import "CC3PointParticleSamples.h"

@implementation asteroidsLayer
@synthesize progressTimer,fireTimer;

- (void)dealloc {
    [super dealloc];
}


/**
 * Override to set up your 2D controls and other initial state.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) initializeControls {
    weaponTime = 1.0;
    
	self.isAccelerometerEnabled = YES;
	self.isTouchEnabled = YES;
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/40];
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    CCSprite * background = [CCSprite spriteWithFile:@"metal_deck_small_right.png"];
    
    [background setPosition:ccp(screenRect.size.height-110,screenRect.size.width-30)];
    [self addChild:background];
    
    CCSprite *background2 = [CCSprite spriteWithFile:@"metal_deck_small_left.png"];
    
    [background2 setPosition:ccp(90,screenRect.size.width-30)];
    [self addChild:background2];
    
    scoreLabel = [[CCLabelTTF labelWithString:@"0" fontName:@"American Typewriter" fontSize:28] retain];
    scoreLabel.color = ccc3(0,0,0);
    scoreLabel.position = ccp(85, screenRect.size.width-21);
    
    [self addChild:scoreLabel];
    
    /*********
     If you want crosshairs
     CCSprite *crossHairs = [CCSprite spriteWithFile:@"crosshair.png"];
     
     [crossHairs setPosition:ccp(screenRect.size.height/2,screenRect.size.width/2)];
     [self addChild:crossHairs]; 
     */
    
    /*********
     If you want lasers and a display to show when player can fire again, you can add this
     
    self.fireTimer = [CCProgressTimer progressWithFile:@"fire_alert_go.png"];
    self.fireTimer.type = kCCProgressTimerTypeRadialCCW;
    self.fireTimer.percentage = 100;
    self.fireTimer.position = ccp(155, screenRect.size.width-21);
    [self addChild:self.fireTimer];
     */
    
    self.progressTimer = [CCProgressTimer progressWithFile:@"health_bar_green.png"];
    self.progressTimer.type = kCCProgressTimerTypeHorizontalBarLR;
    self.progressTimer.percentage = 100;
    self.progressTimer.position = ccp(screenRect.size.height-115,screenRect.size.width-21);
    [self addChild:self.progressTimer];
    
}

-(void)updateHealth :(NSNumber *)health {
    float newLife = [health floatValue];
    if(newLife <= 50)
    {
        [self.progressTimer setSprite:[CCSprite spriteWithFile:@"health_bar_red.png"]];
    }
    
    [self.progressTimer setPercentage:newLife];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	//[self fireLaser];
    //[self schedule:@selector(fireLaser:) interval:0.05f];
	return YES;
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
     //[self unschedule:@selector(fireLaser:)];
}

-(void)reOrient {
    asteroidsScene *roidScene = (asteroidsScene *)cc3Scene;
	[roidScene reOrient];
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration{

    
    asteroidsScene *roidScene = (asteroidsScene *)cc3Scene;
	[roidScene accelTurn:acceleration];
	
}

-(IBAction)fireLaser:(id)sender {
	[cc3Scene fireLaser];
}


-(void)updateScore:(NSNumber *)recScore {
    [scoreLabel setString:[NSString stringWithFormat:@"%d",[recScore intValue]]];
}

-(NSNumber *)retScore {
    return [NSNumber numberWithInt:score];
}

-(void)scheduleEmitterEnd {
    [self schedule:@selector(killEmitterInScene:) interval:1.0];
}
-(void)killEmitterInScene:(id *)sender {
    asteroidsScene *roidScene = (asteroidsScene *)cc3Scene;
    [roidScene killEmitter];
}

-(void)createWeaponsTimer {
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:weaponTime],
                     [CCCallFunc actionWithTarget:self selector:@selector(notifyOfWeaponAvailable)],
                     nil]];
    
    self.fireTimer.percentage = 0.0;
    self.fireTimer.sprite = [CCSprite spriteWithFile:@"fire_alert_hold.png"];
    
    CCProgressFromTo *progress = [CCProgressFromTo actionWithDuration:weaponTime from:0.0 to:100.0];
    [self.fireTimer runAction:progress];
}

-(void)notifyOfWeaponAvailable {
    asteroidsScene *roidScene = (asteroidsScene *)cc3Scene;
    self.fireTimer.sprite = [CCSprite spriteWithFile:@"fire_alert_go.png"];
    [roidScene weaponFree];
}

#pragma mark Updating layer

/**
 * Override to perform set-up activity prior to the scene being opened
 * on the view, such as adding gesture recognizers.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onOpenCC3Layer {}

/**
 * Override to perform tear-down activity prior to the scene disappearing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onCloseCC3Layer {}

/**
 * The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 * The event dispatcher will not dispatch events for which there is no method
 * implementation. Since the touch-move events are both voluminous and seldom used,
 * the implementation of ccTouchMoved:withEvent: has been left out of the default
 * CC3Layer implementation. To receive and handle touch-move events for object
 * picking, uncomment the following method implementation.
 */
/*
 -(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event {
 [self handleTouch: touch ofType: kCCTouchMoved];
 }
 */

@end