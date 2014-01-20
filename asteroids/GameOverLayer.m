#import "GameOverLayer.h"

@implementation GameOverLayer

-(id) init{
    cancelled = FALSE;
     NSLog(@"Game Over Layer");
	self=[super initWithColor:ccc4(0,0,0,255)];    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CCSprite *titleSprite;
    float mod = 1;
    
    @try {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            NSString *filename = [[NSString stringWithFormat:@"title-ipad.png"] retain];
            titleSprite = [CCSprite spriteWithFile:filename];
            [filename release];
            titleSprite.position = ccp(screenHeight/2,680);
            mod = 1.35;
        } else {
            
            if(screenHeight==568){
                NSString *filename = [[NSString stringWithFormat:@"title-568.png"] retain];
                titleSprite = [CCSprite spriteWithFile:filename];
                [filename release];
            }
            else {
                NSString *filename = [[NSString stringWithFormat:@"title.png"] retain];
                titleSprite = [CCSprite spriteWithFile:filename];
                [filename release];
            }
            titleSprite.position = ccp(screenHeight/2,280);
        }
    }
    @catch (NSException * e) {
        NSLog(@"Title Sprite Failure");
        [SceneManager goGameOver];
    }
    [self addChild:titleSprite];
    
    asteroidsAppDelegate *dele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
    score = [[dele fetchScore] retain];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber *highScore;
    BOOL newHigh = FALSE;
    if([prefs valueForKey:@"highScore"]!=nil) {
        highScore = [prefs valueForKey:@"highScore"];
        if([highScore intValue] < [score intValue]) {
            [prefs setValue:score forKey:@"highScore"];
            [prefs synchronize];
            highScore = score;
            newHigh = TRUE;
        }
    } else {
        [prefs setValue:score forKey:@"highScore"];
        [prefs synchronize];
        highScore = score;
        newHigh = TRUE;
    }
    
    
	CCMenuItemFont *retry = [CCMenuItemFont itemFromString:@"Retry" target:self selector: @selector(onRetry:)];
    report = [CCMenuItemFont itemFromString:@"Report Score" target:self selector: @selector(onSendScores:)];
    CCMenuItemFont *mainmenu = [CCMenuItemFont itemFromString:@"Main Menu" target:self selector: @selector(onMainMenu:)];
    retry.fontName = @"American Typewriter";
    retry.fontSize = 25;
    report.fontName = @"American Typewriter";
    report.fontSize = 25;
    mainmenu.fontName = @"American Typewriter";
    mainmenu.fontSize = 25;
	menu = [CCMenu menuWithItems:retry,report,mainmenu, nil];
    [menu alignItemsHorizontallyWithPadding:(30.0*mod)];
    
    CCLabelTTF *highScoreLabel = [[CCLabelTTF labelWithString:@"High Score" fontName:@"American Typewriter" fontSize:24] retain];
    highScoreLabel.color = ccc3(255,255,255);
    highScoreLabel.position = ccp(screenHeight/2-80*mod, screenWidth/2+20*mod);
    [self addChild:highScoreLabel];
    
    CCLabelTTF *highScoreLabelNum = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[highScore intValue]] fontName:@"American Typewriter" fontSize:24] retain];
    highScoreLabelNum.color = ccc3(255,255,255);
    highScoreLabelNum.position = ccp(screenHeight/2-80*mod, screenWidth/2-10*mod);
    [self addChild:highScoreLabelNum];
    
    CCLabelTTF *yourScoreLabel = [[CCLabelTTF labelWithString:@"Your Score" fontName:@"American Typewriter" fontSize:24] retain];
    yourScoreLabel.color = ccc3(255,255,255);
    yourScoreLabel.position = ccp(screenHeight/2+80*mod, screenWidth/2+20*mod);
    [self addChild:yourScoreLabel];
    
    CCLabelTTF *yourScoreLabelNum = [[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d",[score intValue]] fontName:@"American Typewriter" fontSize:24] retain];
    yourScoreLabelNum.color = ccc3(255,255,255);
    yourScoreLabelNum.position = ccp(screenHeight/2+80*mod, screenWidth/2-10*mod);
    [self addChild:yourScoreLabelNum];
    
	menu.position = ccp(screenHeight/2, screenWidth/2-80*mod);
	[self addChild:menu ];
    
	return self;
}

- (void)onRetry:(id)sender {
    cancelled = TRUE;
    [GKLocalPlayer cancelPreviousPerformRequestsWithTarget:self];
    [self removeAllChildrenWithCleanup:YES];
    
    CCLabelTTF *titleLabel = [[CCLabelTTF labelWithString:@"Loading..." fontName:@"American Typewriter" fontSize:34] retain];
    CGSize screenRect = [[UIScreen mainScreen] bounds].size;
    titleLabel.color = ccc3(10,255,10);
    titleLabel.position = ccp(screenRect.height/2, screenRect.width/2);
    [self addChild:titleLabel];
    
    [[CCDirector sharedDirector] drawScene];
    
    asteroidsAppDelegate *dele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSNumber *map = [dele fetchMapNum];
    [score release];
	[SceneManager goGame:map];
}
- (void)onMainMenu:(id)sender {
    cancelled = TRUE;
    [GKLocalPlayer cancelPreviousPerformRequestsWithTarget:self];
    [score release];
    [SceneManager goMenu];
}
- (void)onSendScores:(id)sender {
    report.disabledColor = ccc3(10,255,10);
    report.label.string = @"Sending";
    report.isEnabled = FALSE;
    
    NSLog(@"%@", [GKLocalPlayer localPlayer]);
    if(cancelled == TRUE) return;
    if([GKLocalPlayer localPlayer].authenticated == NO)
	{
		[[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error)
         {
             if(cancelled == TRUE) return;
             if([error.localizedDescription isEqualToString:@"The requested operation has been cancelled."]) {
                 UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                                   message:@"You have cancelled logging into the Game Center too many times. Please open the Game Center app to enable Game Center in Cosmic Cannonball."
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                 [message show];
             }
             NSLog(@"%@", error.localizedDescription);
             
             asteroidsAppDelegate *dele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
             NSNumber *map = [dele fetchMapNum];
             
             NSString *locToSend = [NSString stringWithFormat:@"CCL%dLB",[map intValue]];
              NSLog([NSString stringWithFormat:@"com.otterlabs.cosmiccannonball.CCL%dLB",[map intValue]]);
             GKScore *scoreToSend = [[[GKScore alloc] initWithCategory:locToSend] autorelease];
             
             scoreToSend.value = [score integerValue];
             [scoreToSend reportScoreWithCompletionHandler:^(NSError *error) {
                 if(cancelled == TRUE) return;
                 dispatch_async(dispatch_get_main_queue(), ^(void) {
                     if(cancelled == TRUE) return;
                     if (error == NULL) {
                         report.disabledColor = ccc3(10,255,10);
                         report.label.string = @"Score Sent";
                         report.isEnabled = FALSE;
                     } else {
                         NSLog(@"%@",error.localizedDescription);
                         report.label.string = @"Report Score";
                         report.isEnabled = TRUE;
                     }

                 });
             }];
             
         }];
	} else {
        if(cancelled == TRUE) return;
        asteroidsAppDelegate *dele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSNumber *map = [dele fetchMapNum];
        
        NSString *locToSend = [NSString stringWithFormat:@"CCL%dLB",[map intValue]];
        
        NSLog([NSString stringWithFormat:@"com.otterlabs.cosmiccannonball.CCL%dLB",[map intValue]]);
        
        GKScore *scoreToSend = [[[GKScore alloc] initWithCategory:locToSend] autorelease];
        
        scoreToSend.value = [score integerValue];
        [scoreToSend reportScoreWithCompletionHandler:^(NSError *error) {
            if(cancelled == TRUE) return;
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (error == NULL) {
                    if(cancelled == TRUE) return;
                    report.disabledColor = ccc3(10,255,10);
                    report.label.string = @"Score Sent";
                    report.isEnabled = FALSE;
                } else {
                    report.label.string = @"Report Score";
                    report.isEnabled = TRUE;
                }

            });
        }];
    }
}



@end