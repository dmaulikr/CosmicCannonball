#import "TutorialLayer.h"

@implementation TutorialLayer
@synthesize tut1, tut2, rightChev, leftChev, rightChevMenu, leftChevMenu;

-(id) init{
	self=[super initWithColor:ccc4(0,0,0,255)];

    asteroidsAppDelegate *dele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    currentLoc = 0;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    tutSprite = [CCSprite spriteWithFile:@"tutorial1.png"];
    tutSprite.position = ccp(screenHeight/2,screenWidth/2);
    [self addChild:tutSprite];


    rightChev = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"next.png"] selectedSprite:nil target:self selector:@selector(moveRight:)] retain];
    
    leftChev = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"prev.png"] selectedSprite:nil target:self selector:@selector(moveLeft:)] retain];

    
    CCMenuItemSprite *closeSprite = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"close.png"] selectedSprite:nil target:self selector:@selector(closeBut:)] retain];
    
    closeSprite = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"close.png"] selectedSprite:nil target:self selector:@selector(closeBut:)] retain];
    
    
    CCMenu *closeMenu = [[CCMenu menuWithItems:closeSprite, nil] retain];
    closeMenu.position = ccp(screenHeight/2-210,screenWidth/2+136);
    [self addChild:closeMenu z:3];
    
    closeChev = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"close_text.png"] selectedSprite:nil target:self selector:@selector(closeBut:)] retain];
    
    closeChevMenu = [[CCMenu menuWithItems:closeChev, nil] retain];
    closeChevMenu.position = ccp(screenHeight/2+190, screenWidth/2-120);
    
    rightChevMenu = [[CCMenu menuWithItems:rightChev, nil] retain];
    leftChevMenu = [[CCMenu menuWithItems:leftChev, nil] retain];
    rightChevMenu.position = ccp(screenHeight/2+190, screenWidth/2-120);
    leftChevMenu.position = ccp(screenHeight/2-190,screenWidth/2-120);
    [self addChild:rightChevMenu z:3];
	return self;
}

-(void)moveRight:(id)sender {
    if(currentLoc==0) {
        [tutSprite setTexture: [[CCSprite spriteWithFile:@"tutorial2.png"]texture]];
        currentLoc++;
        [self removeChild:rightChevMenu cleanup:YES];
        [self addChild:closeChevMenu];
        [self addChild:leftChevMenu];
    } else {
        [self close];
    }
}

-(void)closeBut:(id)sender {
    [self close];
}

-(void) close {
    asteroidsAppDelegate *dele = (asteroidsAppDelegate *)[[UIApplication sharedApplication] delegate];
    [SceneManager goMenu];
}

-(void)moveLeft:(id)sender {
    [tutSprite setTexture: [[CCSprite spriteWithFile:@"tutorial1.png"]texture]];
    currentLoc--;
    rightChev = [[CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"next.png"] selectedSprite:nil target:self selector:@selector(moveRight:)] retain];
    [self removeChild:leftChevMenu cleanup:YES];
    [self removeChild:closeChevMenu cleanup:YES];
    [self addChild:rightChevMenu];
    
}

- (void)onCredits:(id)sender{
	[SceneManager goMenu];
}

-(void)upgrade:(id)sender {
    [SceneManager goBuy];
}


@end