#import "LevelLayer.h"

@implementation LevelLayer
@synthesize level1, level2, level3, level4, rightChev, leftChev, rightChevMenu, leftChevMenu, currentMenu, currentMenu2, currentMenu3, currentMenu4, level1Label, level2Label, level3Label, level4Label;

-(id) init{
	self = [super init];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    currentLoc = 0;
    
    CCSprite *backgroundSprite;

    /*
if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    /*
    backgroundSprite = [CCSprite spriteWithFile:@"ipad_background.png"];
    backgroundSprite.position = ccp(screenHeight/2,screenWidth/2);
    [self addChild:backgroundSprite];
    
} else {
    /*
    backgroundSprite = [CCSprite spriteWithFile:@"bg1_p2.jpg"];
    backgroundSprite.position = ccp(240,160);
    [self addChild:backgroundSprite];
}*/
    
    /*
    CCSprite *titleSprite = [CCSprite spriteWithFile:@"title.png"];
    titleSprite.position = ccp(240,220);
    [self addChild:titleSprite];*/
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    BOOL upgraded = FALSE;

    
    
    level1 = [[CCMenuItemLabelAndSprite itemFromLabel:nil normalSprite:[CCSprite spriteWithFile:@"mini_bg1_p1.jpg"] selectedSprite:[CCSprite spriteWithFile:@"mini_bg1_p1.jpg"] target:self selector:@selector(onLevel1:)] retain];

    level2 = [[CCMenuItemLabelAndSprite itemFromLabel:nil normalSprite:[CCSprite spriteWithFile:@"mini_bg2_p1.png"] selectedSprite:[CCSprite spriteWithFile:@"mini_bg2_p1.png"] target:self selector:@selector(onLevel2:)] retain];

    
    level3 = [[CCMenuItemLabelAndSprite itemFromLabel:nil normalSprite:[CCSprite spriteWithFile:@"mini_bg3_p1.png"] selectedSprite:[CCSprite spriteWithFile:@"mini_bg3_p1.png"] target:self selector:@selector(onLevel3:)] retain];
    
    level4 = [[CCMenuItemLabelAndSprite itemFromLabel:[CCLabelTTF labelWithString:@"Eridani Asteroid Belt" dimensions:CGSizeMake(80, 20) alignment:UITextAlignmentCenter fontName:@"American Typewriter" fontSize:34] normalSprite:[CCSprite spriteWithFile:@"mini_bg4_p1.png"] selectedSprite:[CCSprite spriteWithFile:@"mini_bg4_p1.png"] target:self selector:@selector(onLevel4:)] retain];


    rightChev = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"right_chev.png"] selectedSprite:nil target:self selector:@selector(moveRight:)] retain];
    
    leftChev = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"left_chev.png"] selectedSprite:nil target:self selector:@selector(moveLeft:)] retain];

    
	currentMenu = [[CCMenu menuWithItems:level1, nil] retain];
    level1Label = [[CCLabelTTF labelWithString:@"Eridani Asteroid Belt" fontName:@"American Typewriter" fontSize:28] retain];
    level1Label.color = ccc3(10,255,10);
    level1Label.position = ccp(screenHeight/2, (screenWidth/2)+100);
     currentMenu.position = ccp(screenHeight/2, screenWidth/2);
    
    
    currentMenu2 = [[CCMenu menuWithItems:level2, nil] retain];
    level2Label = [[CCLabelTTF labelWithString:@"Mirach Mining Belt" fontName:@"American Typewriter" fontSize:28] retain];
    level2Label.color = ccc3(10,255,10);
    level2Label.position = ccp(screenHeight/2, (screenWidth/2)+100);
    currentMenu2.position = ccp(screenHeight/2, screenWidth/2);
    
    
    currentMenu3 = [[CCMenu menuWithItems:level3, nil] retain];
    level3Label = [[CCLabelTTF labelWithString:@"Alioth Prime Debris Field" fontName:@"American Typewriter" fontSize:28] retain];
    level3Label.color = ccc3(10,255,10);
    level3Label.position = ccp(screenHeight/2, (screenWidth/2)+100);
    currentMenu3.position = ccp(screenHeight/2, screenWidth/2);
    
    currentMenu4 = [[CCMenu menuWithItems:level4, nil] retain];
    level4Label = [[CCLabelTTF labelWithString:@"Jiāng Mine Field" fontName:@"American Typewriter" fontSize:28] retain];
    level4Label.color = ccc3(10,255,10);
    level4Label.position = ccp(screenHeight/2, (screenWidth/2)+100);
    currentMenu4.position = ccp(screenHeight/2, screenWidth/2);
    
    [self addChild:level1Label];
    [self addChild:currentMenu z: 2];
 //   CCMenu *menuDiff2 = [CCMenu menuWithItems:level3, level4, nil];
  //  CCMenu *menuDiff2 = [CCMenu menuWithItems:level3, level4, nil];
    /*
    CCLabelTTF *level4Label = [CCLabelTTF labelWithString:@"Jiāng Mine Field" fontName:@"American Typewriter" fontSize:20];
    level4Label.color = ccc3(255,255,255);
    level4Label.position = ccp(200, 272);
    [self addChild:level4Label];
    
    menuDiff.position = ccp(200, 250);
   [menuDiff alignItemsHorizontallyWithPadding:60.0f];
    //[menuDiff alignItemsInColumns:[NSNumber numberWithInt:2],[NSNumber numberWithInt:2], nil];
    menuDiff2.position = ccp(200, 90);
    [menuDiff2 alignItemsHorizontallyWithPadding:60.0f];

 //  menuDiff.position = ccp(100, 130);
//    [menuDiff alignItemsInColumns:<#(NSNumber *), ...#>, nil:20.0f];
    
    [self addChild:menuDiff z: 2];
    [self addChild:menuDiff2 z: 2];
    */

    rightChevMenu = [[CCMenu menuWithItems:rightChev, nil] retain];
    leftChevMenu = [[CCMenu menuWithItems:leftChev, nil] retain];
    rightChevMenu.position = ccp(screenHeight-50, screenWidth/2);
    leftChevMenu.position = ccp(50, screenWidth/2);
    [self addChild:rightChevMenu z:3];
	return self;
}

-(void)moveRight:(id)sender {
    NSLog(@"Current Loc: %d",currentLoc);
    if(currentLoc<4) {
        switch (currentLoc) {
            case 0: {
                [self removeChild:self.currentMenu cleanup:YES];
                [self addChild:self.currentMenu2 z:2];
                [self removeChild:self.level1Label cleanup:YES];
                [self addChild:self.level2Label z:2];
                [self addChild:leftChevMenu];
                break;
            }
            case 1: {
                [self removeChild:self.currentMenu2 cleanup:YES];
                [self addChild:self.currentMenu3 z:2];
                [self removeChild:self.level2Label cleanup:YES];
                [self addChild:self.level3Label z:2];
                break;
            }
            case 2: {
                [self removeChild:self.currentMenu3 cleanup:YES];
                [self addChild:self.currentMenu4 z:2];
                [self removeChild:self.level3Label cleanup:YES];
                [self addChild:self.level4Label z:2];
                [self removeChild:self.rightChevMenu cleanup:YES];
                break;
            }
                
        }
    currentLoc++;
    } else {
         [self removeChild:self.rightChevMenu cleanup:YES];
    }
}
-(void)moveLeft:(id)sender {
    if(currentLoc>0) {
        switch (currentLoc) {
            case 1: {
                [self removeChild:self.currentMenu2 cleanup:YES];
                [self addChild:self.currentMenu z:2];
                [self removeChild:self.level2Label cleanup:YES];
                [self addChild:self.level1Label z:2];
                [self removeChild:self.leftChevMenu cleanup:YES];
                break;
            }
            case 2: {
                [self removeChild:self.currentMenu3 cleanup:YES];
                [self addChild:self.currentMenu2 z:2];
                [self removeChild:self.level3Label cleanup:YES];
                [self addChild:self.level2Label z:2];
                break;
            }
            case 3: {
                [self removeChild:self.currentMenu4 cleanup:YES];
                [self addChild:self.currentMenu3 z:2];
                [self removeChild:self.level4Label cleanup:YES];
                [self addChild:self.level3Label z:2];
                [self addChild:rightChevMenu];
                break;
            }
        }
        currentLoc--;
    } else {
        [self removeChild:self.leftChevMenu cleanup:YES];
    }
}

- (void)onCredits:(id)sender{
	[SceneManager goMenu];
}

-(void)upgrade:(id)sender {
    [SceneManager goBuy];
}

-(void)onLevel1:(id)sender {
    [self removeAllChildrenWithCleanup:YES];
    
    CCLabelTTF *titleLabel = [[CCLabelTTF labelWithString:@"Loading..." fontName:@"American Typewriter" fontSize:34] retain];
    CGSize screenRect = [[UIScreen mainScreen] bounds].size;
    titleLabel.color = ccc3(10,255,10);
    titleLabel.position = ccp(screenRect.height/2, screenRect.width/2);
    [self addChild:titleLabel];
    
     [[CCDirector sharedDirector] drawScene];
    
    map = [NSNumber numberWithInt:1];
    [SceneManager goGame:map];
}
-(void)onLevel2:(id)sender {
    [self removeAllChildrenWithCleanup:YES];
    
    CCLabelTTF *titleLabel = [[CCLabelTTF labelWithString:@"Loading..." fontName:@"American Typewriter" fontSize:34] retain];
    CGSize screenRect = [[UIScreen mainScreen] bounds].size;
    titleLabel.color = ccc3(10,255,10);
    titleLabel.position = ccp(screenRect.height/2, screenRect.width/2);
    [self addChild:titleLabel];
    
    [[CCDirector sharedDirector] drawScene];
    
    map = [NSNumber numberWithInt:2];
    [SceneManager goGame:map];
}
-(void)onLevel3:(id)sender {
    [self removeAllChildrenWithCleanup:YES];
    
    CCLabelTTF *titleLabel = [[CCLabelTTF labelWithString:@"Loading..." fontName:@"American Typewriter" fontSize:34] retain];
    CGSize screenRect = [[UIScreen mainScreen] bounds].size;
    titleLabel.color = ccc3(10,255,10);
    titleLabel.position = ccp(screenRect.height/2, screenRect.width/2);
    [self addChild:titleLabel];
    
     [[CCDirector sharedDirector] drawScene];
    
    map = [NSNumber numberWithInt:3];
    [SceneManager goGame:map];
}
-(void)onLevel4:(id)sender {
    [self removeAllChildrenWithCleanup:YES];
    
    CCLabelTTF *titleLabel = [[CCLabelTTF labelWithString:@"Loading..." fontName:@"American Typewriter" fontSize:34] retain];
    CGSize screenRect = [[UIScreen mainScreen] bounds].size;
    titleLabel.color = ccc3(10,255,10);
    titleLabel.position = ccp(screenRect.height/2, screenRect.width/2);
    [self addChild:titleLabel];
    
     [[CCDirector sharedDirector] drawScene];
    
    map = [NSNumber numberWithInt:4];
    [SceneManager goGame:map];
}

- (void)onNewGame:(id)sender{
	[SceneManager goGame:map];
}

@end