/**
 *  asteroidsLayer.h
 *  asteroids
 *
 *  Created by Eric Schmitt on 9/20/12.
 *  Copyright __MyCompanyName__ 2012. All rights reserved.
 */


#import "CC3Layer.h"


/** A sample application-specific CC3Layer subclass. */
@interface asteroidsLayer : CC3Layer <UIAccelerometerDelegate>{
    UIAccelerometer *accelerometer;
    CCProgressTimer *progressTimer;
    CCProgressTimer *fireTimer;
    int score;
    CCLabelTTF *scoreLabel;
    float weaponTime;
}
@property (nonatomic, retain) UIAccelerometer *accelerometer;
@property (nonatomic, retain) CCProgressTimer *progressTimer;
@property (nonatomic, retain) CCProgressTimer *fireTimer;
@property (nonatomic, retain) CCLabelTTF *scoreLabel;

-(void)updateHealth :(NSNumber *)health;
-(NSNumber *)retScore;
-(void)scheduleEmitterEnd;
-(void)updateScore:(NSNumber *)recScore;
-(void)reOrient;
-(void)createWeaponsTimer;


@end
