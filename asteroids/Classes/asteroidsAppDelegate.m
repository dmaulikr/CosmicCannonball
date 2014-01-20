/**
 *  asteroidsAppDelegate.m
 *  asteroids
 *
 *  Created by Eric Schmitt on 9/20/12.
 *  Copyright __MyCompanyName__ 2012. All rights reserved.
 */

#import "asteroidsAppDelegate.h"
#import "asteroidsLayer.h"
#import "asteroidsScene.h"
#import "CC3EAGLView.h"
#import "SceneManager.h"

@implementation asteroidsAppDelegate

@synthesize window, score;

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[viewController release];
	[super dealloc];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void) applicationDidFinishLaunching:(UIApplication*)application {
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    //CHANGE TO FALSE LATER
    upgraded = FALSE;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
   upgraded = TRUE;
    
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	CCDirector *director = [CCDirector sharedDirector];
    
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeLeft];
    
    
	[director setAnimationInterval:1.0/40];
	[director setDisplayFPS:NO];

	EAGLView *glView = [CC3EAGLView viewWithFrame: [window bounds]
									  pixelFormat: kEAGLColorFormatRGBA8
									  depthFormat: GL_DEPTH_COMPONENT16_OES
							   preserveBackbuffer: NO
									   sharegroup: nil
									multiSampling: NO
								  numberOfSamples: 4];


	[glView setMultipleTouchEnabled: YES];
	[director setOpenGLView:glView];

	[window addSubview: glView];
	[window makeKeyAndVisible];
    
    myViewController= [[UIViewController alloc] init];
    [[[CCDirector sharedDirector] openGLView] addSubview:myViewController.view];
    myViewController.view.hidden = TRUE;
    
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    [SceneManager goMenu];
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

-(void)updateScore:(NSNumber *)recScore {
    int scoreTemp1 = [recScore intValue];
    int scoreTemp2 = [self.score intValue];
    int scoreTemp = scoreTemp1 + scoreTemp2;
    self.score = [NSNumber numberWithInt:scoreTemp];
    [myLayer updateScore:self.score];
}

-(void)createWeaponsTimer {
    [myLayer createWeaponsTimer];
}

-(void) resumeApp { [[CCDirector sharedDirector] resume]; }

- (void)applicationDidBecomeActive: (UIApplication*) application {
	
	[NSTimer scheduledTimerWithTimeInterval: 0.5f
									 target: self
								   selector: @selector(resumeApp)
								   userInfo: nil
									repeats: NO];
	
	// If dropping to 40fps is not an issue, remove above, and uncomment the following to avoid delay.
	//	[self resumeApp];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

-(NSNumber *)fetchMapNum {
    return mapNum;
}
-(NSNumber *)fetchScore {
    return self.score;
}

-(void)scheduleEmitterEnd {
    [myLayer scheduleEmitterEnd];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
    //[myLayer reOrient];
	[[CCDirector sharedDirector] startAnimation];
}

-(void)configureToDiff:(NSNumber *)sentDiff {
    
    difficulty = sentDiff;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

-(void)updateHealth :(NSNumber *)health {
    [myLayer updateHealth :health];
}

-(void)playerKilled {
    [SceneManager goGameOver];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        [myLayer stopAllActions];
        [self startGame:mapNum];
        
	}
	else {
		[myLayer stopAllActions];
        [SceneManager goMenu];
	}
}

-(void) stopActions {
    [myLayer stopAllActions];
}

-(NSNumber *)reMapType {
    return mapNum;
}



-(void)displayLeaderBoard
{
        if([GKLocalPlayer localPlayer].authenticated == NO)
        {
            [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^(void)
                {
                      [self displayBoards];
                });
             }];
        } else {
            [self displayBoards];
        }
}

-(void)displayBoards {
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
	if (leaderboardController != NULL)
	{
        leaderboardController.category = @"CCALB";
		leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
		leaderboardController.leaderboardDelegate = self;
		[myViewController presentModalViewController: leaderboardController animated: YES];
        myViewController.view.hidden = NO;
	}
    
	[leaderboardController release];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)leaderboardController
{
    
	[myViewController dismissModalViewControllerAnimated:YES];
    myViewController.view.hidden = YES;
}

-(void)startGame :(NSNumber *)map {
    self.score = [NSNumber numberWithInt:0];
    

    myLayer = nil;
    mapNum = map;
    
    if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
        [CCDirector setDirectorType:kCCDirectorTypeDefault];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    CC3Layer* cc3Layer = [asteroidsLayer node];
    [cc3Layer scheduleUpdate];
    
    cc3Layer.cc3Scene = [asteroidsScene scene];
    [cc3Layer.cc3Scene configureToDiff:difficulty];
    ControllableCCLayer* mainLayer = cc3Layer;

    playTime = [NSDate date];
    CCScene *scene = [CCScene node];
    [scene addChild: mainLayer];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.50f scene:scene]];
    myLayer = (asteroidsLayer *)cc3Layer;
}

@end