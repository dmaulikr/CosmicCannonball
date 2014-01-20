#import "MenuLayer.h"

@implementation MenuLayer

-(id) init{
	self = [super init];

    CCDirector * director = [CCDirector sharedDirector];
    CGSize sizeA = [director winSize];
    CGFloat screenWidth = sizeA.height;
    CGFloat screenHeight = sizeA.width;
    

    CCSprite *backgroundSprite;
    
    NSString *modifier = @"";
    
    CCSprite *titleSprite;
    
if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    /*
    backgroundSprite = [CCSprite spriteWithFile:@"ipad_background.png"];
    backgroundSprite.position = ccp(screenHeight/2,screenWidth/2);
    [self addChild:backgroundSprite z:-2];
    */
    titleSprite = [CCSprite spriteWithFile:@"title-ipad.png"];
    titleSprite.position = ccp(screenHeight/2,680);
    modifier = @"ipad_";
 } else {
     /*
        backgroundSprite = [CCSprite spriteWithFile:@"bg1_p2.jpg"];
        backgroundSprite.position = ccp(240,160);
        [self addChild:backgroundSprite z:-100];
      */
    if(screenHeight==568)
        titleSprite = [CCSprite spriteWithFile:@"title-568.png"];
    else
        titleSprite = [CCSprite spriteWithFile:@"title.png"];
    titleSprite.position = ccp(screenHeight/2,280);
 }
    
    CCSprite *menuRightSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@main_menu_right.png",modifier]];
    menuRightSprite.position = ccp(screenHeight-100,110);
    [self addChild:menuRightSprite];
    
    CCSprite *menuLeftSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@main_menu_left.png",modifier]];
    menuLeftSprite.position = ccp(100,110);
    [self addChild:menuLeftSprite];

    
    [self addChild:titleSprite z:1];
    
    CCMenuItemSprite *leaderboard = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"menu_leaders.png"] selectedSprite:[CCSprite spriteWithFile:@"menu_leaders.png"]  target:self selector:@selector(leaderboards:)];
    CCMenuItemFont *opts = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"menu_options.png"] selectedSprite:[CCSprite spriteWithFile:@"menu_options.png"]  target:self selector:@selector(onOpts:)];
    CCMenuItemSprite *tutorial = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"tutorialBut.png"] selectedSprite:[CCSprite spriteWithFile:@"tutorialBut.png"]  target:self selector:@selector(tutorial:)];
    
    CCMenu *menu2;
    

    menu2 = [CCMenu menuWithItems:tutorial, leaderboard, opts, nil];
    menu2.position = ccp(100, 115);
    [menu2 alignItemsVerticallyWithPadding: 0.0];

    
    easy = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"easy.png"] selectedSprite:[CCSprite spriteWithFile:@"easy.png"]  target:self selector:@selector(onEasy:)];
    
    normal = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"normal.png"] selectedSprite:[CCSprite spriteWithFile:@"normal.png"]  target:self selector:@selector(onNormal:)];
    
    hard = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"insane.png"] selectedSprite:[CCSprite spriteWithFile:@"insane.png"]  target:self selector:@selector(onHard:)];

	CCMenu *menuDiff = [CCMenu menuWithItems:easy, normal, hard,  nil];
    
    menuDiff.position = ccp(screenHeight-100,95);
    [menuDiff alignItemsVerticallyWithPadding:0.0];
    
if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
    menuRightSprite.position = ccp(screenHeight-100,150);
    menuLeftSprite.position = ccp(100,150);
    menuDiff.position = ccp(screenHeight-100,165);
    menu2.position = ccp(100, 165);
}
    
    [self addChild:menuDiff z: 2];
     [self addChild:menu2 z: 2];
    
	return self;
}

-(void)onEasy:(id)sender {
    easy.color = ccc3(10,255,10);
    normal.color = ccc3(255,255,255);
    hard.color = ccc3(255,255,255);

    diff = [NSNumber numberWithInt:2];
    [SceneManager goLevelPicker:diff];
}
-(void)onNormal:(id)sender {
    easy.color = ccc3(255,255,255);
    normal.color = ccc3(10,255,10);
    hard.color = ccc3(255,255,255);

    diff = [NSNumber numberWithInt:4];
    [SceneManager goLevelPicker:diff];
}
-(void)onHard:(id)sender {
    easy.color = ccc3(255,255,255);
    hard.color = ccc3(10,255,10);
    normal.color = ccc3(255,255,255);

    diff = [NSNumber numberWithInt:5];
    [SceneManager goLevelPicker:diff];
}/*
-(void)onInsane:(id)sender {
    easy.color = ccc3(255,255,255);
    insane.color = ccc3(10,255,10);
    hard.color = ccc3(255,255,255);
    normal.color = ccc3(255,255,255);
    reality.color = ccc3(255,255,255);
    diff = [NSNumber numberWithInt:3];
}
-(void)onReality:(id)sender {
    easy.color = ccc3(255,255,255);
    reality.color = ccc3(10,255,10);
    hard.color = ccc3(255,255,255);
    insane.color = ccc3(255,255,255);
    normal.color = ccc3(255,255,255);
    diff = [NSNumber numberWithInt:4];
}*/

- (void)onNewGame:(id)sender{
	[SceneManager goLevelPicker:diff];
}
- (void)leaderboards:(id)sender{
	asteroidsAppDelegate *dele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [dele displayLeaderBoard];
}

-(void)onOpts:(id)sender {
    [SceneManager goOpts];
}

-(void)tutorial:(id)sender {
    [SceneManager goTut];
}

- (void)onCredits:(id)sender{
	[SceneManager goMenu];
}
@end