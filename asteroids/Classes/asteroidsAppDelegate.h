/**
 *  asteroidsAppDelegate.h
 *  asteroids
 *
 *  Created by Eric Schmitt on 9/20/12.
 *  Copyright __MyCompanyName__ 2012. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "CCNodeController.h"
#import "CC3Scene.h"
#import "asteroidsLayer.h"
#import "MenuLayer.h"
#import "ARIAPHelper.h"

@interface asteroidsAppDelegate : NSObject <UIApplicationDelegate, GKLeaderboardViewControllerDelegate, GameCenterManagerDelegate> {
        UIWindow* window;
        CCNodeController* viewController;
        asteroidsLayer *myLayer;
        
        NSDate *playTime;
        float runningTimer;
    
        NSNumber *difficulty;
    
        NSNumber *mapNum;
    
        UIViewController *myViewController;
        UIViewController *adWrap;
    
    NSNumber *score;
    
        BOOL upgraded;
    BOOL iapLoaded;

    }
    
@property (nonatomic, retain) UIWindow* window;
@property (nonatomic, retain) asteroidsLayer *myLayer;
@property (nonatomic, retain) NSNumber *score;

-(void)updateHealth :(NSNumber *)health;
-(void)playerKilled;
-(void)startGame:(NSNumber *)map;
-(void)configureToDiff:(NSNumber *)sentDiff;
-(NSNumber *)fetchMapNum;
-(NSNumber *)fetchScore;
-(void)scheduleEmitterEnd;
-(void)updateScore:(NSNumber *)recScore;
-(void)displayLeaderBoard;
-(void)upgrade;
-(void)stopActions;
-(void)createWeaponsTimer;
    
    @end
